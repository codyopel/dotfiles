#!/usr/bin/env elvish

use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/re

# Configuration Options
var MUSIC_DIRECTORY = "Z:/roberts/music" # Should be an absolute path
var MUSIC_DIRECTORY_TRANSCODE = "Z:/roberts/music/music-transcodes"

var inputArtist = $args

if $inputArtist null then {
    fail "ERROR: no input provided"
}

fn working_dirctory {|file|
    os:dirname $file
}

# TODO: regex strip illegal chars
fn output_filename {|file|
    var base = (path:basename $file)
    re:replace (path:ext $base)'$' '.m4a' $base
}

# TODO: resampling
# TODO: ebur128
# TODO: dsd to pcm

fn probe {|fixme|
    
}

fn transcode_audio_file {|input output|
      exec:cmd ffmpeg -y ^
        -i $input ^
        -c:a libfdk_acc ^
        -b:a 128k ^
        $output
}

fn is_audio_file {|file|
    if FIXME (file_extension) ['flac' 'ogg' 'm4a' 'mp3' 'wv'] {
        put true
        return
    }

    put false
}

# Sanitize input to prevent spaces from causing errors
var artistAddPath = "$remoteMusicDirectory/\"${@}\""

# Check for specified formats and convert to ogg
os:scandir ''
find "$HOME/Music/$inputArtist" -depth -name '*' | \
while read curWorkFile ; do
  curWorkFileExt="${curWorkFile##*.}"
  case "$curWorkFileExt" in
      transcode_audio_file
      rm -f "$curWorkFile"
      ;;
    *)
      echo "Skipping: ${curWorkFile}"
      ;;
  esac
done
