# TODO:
# - Port dotfiles manager and write an updater
#   https://github.com/chlorm/kratos/blob/c82657c9565ce041ade093c473c3f6d0b25be0ad/modules/updater/main.bash
# - Handle TERM environment variable
# - Wrapper for prompt themes
# - HIGHDPI
# - Port pulseaudio wrapper (e.g. volume)
# - Port user-agent handling
#   https://github.com/chlorm/kratos/tree/c82657c9565ce041ade093c473c3f6d0b25be0ad/plugins/user-agent
# - Port ssh key management
#   https://github.com/chlorm/kratos/tree/c82657c9565ce041ade093c473c3f6d0b25be0ad/plugins/ssh
# - Use another or port Git wrapper
#   https://github.com/chlorm/kratos/tree/c82657c9565ce041ade093c473c3f6d0b25be0ad/plugins/git
# - Password prompt
# - Y/N prompt
# - PATH manipulation?
# - GOPATH / add to PATH
# - https://github.com/chlorm/kratos/tree/c82657c9565ce041ade093c473c3f6d0b25be0ad/plugins/golang
# - Completions
# - Automate setting EDITOR/VISUAL environment variables
#   https://github.com/chlorm/kratos/blob/c82657c9565ce041ade093c473c3f6d0b25be0ad/modules/editor/main.bash
# - Port pager abstractions
#   https://github.com/chlorm/kratos/blob/c82657c9565ce041ade093c473c3f6d0b25be0ad/modules/pager/main.bash
#
# Wrappers: (abstract platform specifics)
# - Upper/Lower casing strings
# - math (mode/round)
# - structured logging?
# - cpu
# - argument parsing

# Aliases
# alias nixpaste="curl -F 'text=<-' http://nixpaste.noip.me"
# alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

use epm
epm:install &silent-if-installed=$true github.com/chlorm/kratos
#use github.com/chlorm/kratos/kratos
use github.com/chlorm/kratos/kratos-init
epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
use github.com/chlorm/elvish-util-wrappers/btrfs
use github.com/chlorm/elvish-util-wrappers/nix
use github.com/chlorm/elvish-util-wrappers/nm

edit:abbr['~t'] = ~/Projects/triton

E:EMAIL = 'cwopel@chlorm.net'

E:DOTFILES_REPO = 'https://github.com/codyopel/dotfiles.git'

E:GIT_NAME = 'Cody Opel'
E:GIT_EMAIL = $E:EMAIL

if ?(has-env 'SSH_ASKPASS' >/dev/null) {
  unset-env 'SSH_ASKPASS'
}

E:EDITOR = 'vim'
E:VISUAL = 'vim'

E:NIX_PATH = 'nixpkgs='(get-env HOME)'/Projects/triton:nixos-config=/etc/nixos/configuration.nix:'

fn ls [@a]{ e:ls '--color' $@a }

fn ls-colors {
  # Linux/Cygwin
  local:dir-colors = (dircolors -b | grep -oP "(?<=').*(?=')")
  E:LS_COLORS = $dir-colors
  # FreeBSD
  E:CLICOLOR = 1
  E:LSCOLORS = 'ExGxFxdxCxDhDxaBadaCeC'
}

edit:prompt = {
  edit:styled (whoami) green
  edit:styled '@' 'dim;white'
  if (has-env SSH_CLIENT) {
    edit:styled (hostname) 'bold;red'
  } else {
    edit:styled (hostname) 'bold;white'
  }
  edit:styled '[' 'dim;white'
  edit:styled (tilde-abbr $pwd) red
  edit:styled ']' 'dim;white'
  edit:styled '〉' 'bold;cyan'
}
edit:rprompt = { }

fn update-machines {
  nix:rebuild-system 'boot' --option binary-caches '""'
  nix:rebuild-envs --option binary-caches '""'
  nixos-closures = (nix:find-nixos-closures)
  nix-config-closures = [(nix:find-nixconfig-closures)]

  local:machines = [ ]
  local:hostname = (hostname)
  if (!=s $hostname 'NOS-4-A2') {
    machines = [ $@machines '10.1.1.5' ]
  }
  if (!=s $hostname 'Raenok') {
    machines = [ $@machines '10.1.1.7' ]
  }
  for local:i $machines {
    nix:copy-closures $i $@nixos-closures $@nix-config-closures
  }
}

fn mssh {
  sudo sshfs \
    '-o' 'allow_other' 'cwopel@10.1.1.50:/home/cwopel' ~/tmnt
}

fn beetu [@args]{
  beet '-c' $E:HOME'/.config/beets/config-unconfirmed.yaml' $@args
}

fn youtube [@args]{
  youtube-dl '-f' "bestvideo+bestaudio" '--no-check-certificate' \
    '--prefer-insecure' '--console-title' $@args
}

fn dotfiles-dir { put $E:HOME'/.dotfiles' }

