#!/usr/bin/env bash
#
#                      Amazon Cloud Drive - Object Store
#
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>
# All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -o errexit
set -o errtrace
set -o functrace
set -o pipefail

source "$(lib-bash)"

trap 'Log::Func' DEBUG
trap 'ACDOS::Cleanup' SIGINT SIGTERM EXIT
trap -- 'ACDOS::Cleanup ; Log::Trace ; exit 1' ERR

function ACDOS::7zip.compress {
  Function::RequiredArgs '3' "$#"
  local -r File="${1}"
  local FileBase
  local -r Hash="${2}"
  local -r Password="${3}"

  FileBase="$(basename "${File}")"

  7za 'a' \
    '-t7z' \
    '-mhe=on' \
    '-mx=0' \
    '-v20m' \
    "-p${Password}" \
    "${_tmpdir_}/zip-fragments/${Hash}.7z" \
    "${File}"
}

function ACDOS::7zip.extract {
  Function::RequiredArgs '3' "$#"
  local -r File="${1}"
  local -r ZipFile="${2}"
  local -r Password="${3}"

  OutputDir="$(dirname "${File}")"

  7za 'x' \
    "-p${Password}" \
    "-o${OutputDir}" \
    "${ZipFile}"
}

function ACDOS::AcdCli {
  Function::RequiredArgs '3' "$#"
  local -r Action="${1}"
  local -a AdditionalArgs
  local ContinueIter='true'
  # local Iter=0
  local Path1
  local Path2
  local -r PathLocal="${2}"
  local -r PathRemote="${3}"

  if [ "${Action}" == 'download' ] ; then
    Path1="${PathRemote}"
    Path2="${PathLocal}"
  elif [ "${Action}" == 'upload' ] ; then
    Path1="${PathLocal}"
    Path2="${PathRemote}"
    AdditionalArgs+=('--overwrite')
  else
    Log::Message 'error' "invalid action: ${Action}"
    return 1
  fi

  while [ "${ContinueIter}" == 'true' ] ; do
    # if [ ${Iter} -gt 5 ] ; then
    #   Log::Message 'error' "transient network failure"
    #   return 1
    # fi
    acd_cli sync
    acd_cli "${Action}" ${AdditionalArgs[@]} "${Path1}" "${Path2}" || {
      continue
    }
    ContinueIter='false'
    # Iter=$(( ${Iter} + 1 ))
  done
}

function ACDOS::Cleanup {
  if [ -d "${_tmpdir_}" ] ; then
    rm -rf "${_tmpdir_}" >&2
  fi
}

function ACDOS::Openssl.hash {
  Function::RequiredArgs '1' "$#"
  local -r File="${1}"

  openssl sha256 "${File}" 2>&- | awk -F '= ' '{print $2 ; exit}'
}

function ACDOS::Retrieve {
  Function::RequiredArgs '1' "$#"
  local -a FetchObjects
  local -r File="${1}"
  local FindIndex
  local Password

  Password="$(jq -r -c -M '.Password' "${File}")"

  mapfile -t FetchObjects < <(jq -r -c -M '.ZipFragments[].file' "${File}")

  for i in "${FetchObjects[@]}" ; do
    ACDOS::AcdCli 'download' "${_tmpdir_}/zip-fragments" "/object-store/${i}"
    wait
  done

  FindIndex="$(
    jq -r -c -M \
        ".ZipFragments[]|select(.file|contains(\"7z.001\")).file" "${File}"
  )"
  Var::Type.string "${FindIndex}"

  ACDOS::7zip.extract "${File}" "${_tmpdir_}/zip-fragments/${FindIndex}" \
      "${Password}"
}

function ACDOS::Send {
  Function::RequiredArgs '1' "$#"
  local -r File="${1}"
  local FileBase
  local Hash
  local -a ZipFragments

  FileBase="$(basename "${File}")"

  Password="$(
    echo "$RANDOM" |
        openssl dgst -sha256 2>&- |
        awk -F '= ' '{print $2 ; exit}'
  )"

  Hash="$(ACDOS::Openssl.hash "${File}")"

  ACDOS::7zip.compress "${File}" "${Hash}" "${Password}"

  mapfile -t ZipFragments < <(
    find "${_tmpdir_}/zip-fragments" -name '*.7z.*'
  )

  echo '{' > "${_tmpdir_}/${FileBase}.json"
  echo "  \"Password\": \"${Password}\"," >> "${_tmpdir_}/${FileBase}.json"
  echo '  "ZipFragments": [' >> "${_tmpdir_}/${FileBase}.json"
  for i in "${ZipFragments[@]}" ; do
    ACDOS::AcdCli 'upload' "${i}" '/object-store/'
    echo "    { \"file\": \"$(basename "${i}")\" }," >> \
        "${_tmpdir_}/${FileBase}.json"
  done
  echo '  ]' >> "${_tmpdir_}/${FileBase}.json"
  echo '}' >> "${_tmpdir_}/${FileBase}.json"

  # Fix trailing comma in json
  perl -00pe 's/,(?!.*,)//s' "${_tmpdir_}/${FileBase}.json" > \
      "${_tmpdir_}/${FileBase}.json.1"
  mv "${_tmpdir_}/${FileBase}.json.1" "${_tmpdir_}/${FileBase}.json"

  cp -v "${_tmpdir_}/${FileBase}.json" "$(dirname "${File}")"
}

function ACDOS::Main {
  Function::RequiredArgs '2' "$#"
  declare _tmpdir_
  local File
  local -r Mode="${1}" ; shift

  Path::Check '7za'
  Path::Check 'acd_cli'
  Path::Check 'jq'
  Path::Check 'openssl'
  Path::Check 'perl'

  if [ ! -f "${HOME}/.cache/acd_cli/oauth_data" ] ; then
    Log::Message 'error' 'acd_cli not initialized'
    return 1
  fi
  acd_cli sync

  File="$(readlink -f "${@}")"

  _tmpdir_="$(dirname "${File}")/.acd-os.$RANDOM"
  mkdir -pv "${_tmpdir_}/zip-fragments"

  if [[ "${Mode}" != @('send'|'retrieve') ]] ; then
    Log::Message 'error' "invalid mode: ${Mode}"
    return 1
  fi

  if [ ! -f "${File}" ] ; then
    Log::Message 'error' "\`${Mode}\` mode requires a file"
    return 1
  fi

  if [ "${Mode}" == 'send' ] ; then
    ACDOS::Send "${File}"
  elif [ "${Mode}" == 'retrieve' ] ; then
    ACDOS::Retrieve "${File}"
  fi

  ACDOS::Cleanup
}

ACDOS::Main $@

exit 0
