use epm
use str
#epm:install &silent-if-installed=$true github.com/chlorm/elvish-stl
#epm:install &silent-if-installed=$true github.com/chlorm/elvish-term
#epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
use github.com/chlorm/elvish-stl/env
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-stl/re
use github.com/chlorm/elvish-term/ansi
use github.com/chlorm/elvish-term/osc
# CLI helpers
use github.com/chlorm/elvish-util-wrappers/audio
#use github.com/chlorm/elvish-util-wrappers/btrfs
#use github.com/chlorm/elvish-util-wrappers/git
#use github.com/chlorm/elvish-util-wrappers/nix
#use github.com/chlorm/elvish-util-wrappers/nm


set-env LANG C.UTF-8

# TODO: don't populate env vars inside rc
fn build-dir-list {
    #epm:install &silent-if-installed=$true github.com/chlorm/elvish-xdg
    use github.com/chlorm/elvish-xdg/xdg-dirs
    xdg-dirs:populate-env

    var initDirs = [ ]
    # XDG Directories
    for i $xdg-dirs:XDG-VARS {
        set initDirs = [ $@initDirs (get-env $i) ]
    }

    # Linux trash directories
    if $platform:is-linux {
        set initDirs = [
            $@initDirs
            (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/files/'
            (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/info/'
        ]
    }

    # Custom personal directories
    set initDirs = [
        $@initDirs
        (path:join (path:home) 'Projects')
    ]

    put (str:join $env:DELIMITER $initDirs)
}

set-env EMAIL 'cwopel@chlorm.net'
set-env GIT_NAME 'Cody Opel'
set-env GIT_EMAIL (get-env EMAIL)
# FIXME: this will eventually be multiple repos and need some other format.
set-env DOTFILES_REPO 'https://github.com/codyopel/dotfiles.git'
set-env DOTFILE_REPOS '{
    # FIXME: need to either make this just an array, have multiple top-level
    #        keys, or a generic key name.  Would be ideal to support archives
    #        and other formats at some point.
    "repos": [
        "https://github.com/codyopel/dotfiles",
        "https://github.com/chlorm/dotfiles-keyring-services",
        "https://github.com/chlorm/dotfiles-vim"
    ]
}'

set-env KRATOS_INIT_DOTFILES_DIRS (path:join (path:home) '.dotfiles')
set-env KRATOS_INIT_DIRS (build-dir-list)
#epm:install &silent-if-installed=$true github.com/chlorm/kratos
use github.com/chlorm/kratos/kratos-init

# TODO: move to module
fn ls {|@a|
    try {
        e:eza $@a 2>$os:NULL
    } catch _ {
        try {
            e:ls '--color' $@a 2>$os:NUll
        } catch _ {
            try {
                e:ls '-G' $@a 2>$os:NULL
            } catch _ {
                e:ls $@a
            }
        }
    }
}

fn settitle {|title|
    printf "%sk%s%s" $ansi:ESC $title $ansi:ST
}

set edit:abbr['~t'] = ~/Projects/triton
set E:NIX_PATH = 'nixpkgs='(get-env HOME)'/Projects/triton:nixos-config=/etc/nixos/configuration.nix:'

fn update-machines {
    nix:rebuild-system 'boot' --option binary-caches '""'
    nix:rebuild-envs --option binary-caches '""'
    var nixos-closures = (nix:find-nixos-closures)
    var nix-config-closures = [ (nix:find-nixconfig-closures) ]

    var machines = [ ]
    var hostname = (platform:hostname)
    if (!=s $hostname 'miranova') {
        set machines = [ $@machines 'miranova.aurora' ]
    }
    if (!=s $hostname 'Raenok') {
        set machines = [ $@machines 'raenok.aurora' ]
    }
    for i $machines {
        nix:copy-closures $i $@nixos-closures $@nix-config-closures
    }
}

fn vi {|@a| e:nvim $@a }
fn vim {|@a| e:nvim $@a }

fn clear { osc:clear }

# Force plexmediaplayer to only use X.Org
fn plexmediaplayer {
    tmp E:QT_QPA_PLATFORM = xcb; exec plexmediaplayer
}

fn namer {|@args|
  python C:\Users\cwopel\.local\bin\fixname.py $@args
}

fn namerall {|@args|
  for i [ (put *) ] {
    renamer $i $@args
  }
}

fn rename {|repl new file &c=$false|
  use re
  use github.com/chlorm/elvish-stl/os
  var newfile = (re:replace $repl $new $file)
  if (==s $file $newfile) {
    return
  }
  echo $file '->' $newfile
  if $c {
    os:move $file $newfile
  }
}

fn renameall {|repl new &c=$false|
  for i [(put *)] {
    rename &c=$c $repl $new $i
  }
}

fn sl {
    put *
}

fn yt {|@args|
    yt-dlp -f 'bv*+ba' $@args
}

fn jdremux {
    var v = (put *.mp4)
    var a = $nil
    try {
        set a = (put *.m4a)
    } catch _ {
        set a = (put *.opus)
    }
    var c = (put *.jpg)
    var d = ''
    try {
        set d = (slurp < *.txt)
    } catch _ { }
    if (eq $a $nil) { fail }
    ffmpeg -i $v -i $a -i $c -map 0:0 -map 1:0 -map 2:0 -c copy -disposition:2 attached_pic -metadata comment=$d out.mp4
    try { os:remove $v } catch _ { }
    try { os:remove $a } catch _ { }
    try { os:remove $c } catch _ { }
    try {
        for i [ (put *.srt) ] {
            os:remove $i
        }
    } catch _ { }
    try { os:remove (put *.txt) } catch _ { }
    os:move out.mp4 $v
    rename '(.*) \([0-9]+p_[0-9]+fps_(?:H264|VP9)-[0-9]+kbit_[A-Z]+\)(.mp4)$' '$1$2' $v &c
}

{{ if .isWindows }}

# TODO: -r
fn cp {|@args|
    if (> (count $args) 2) {
        try {
            var _ = (os:is-dir $args[-1])
        } catch e {
            fail $e
        }
        for i $args[0..-1] {
            os:copy $i $args[-1]
        }
        return
    }

    os:copy $args[0] $args[1]
}

fn htop {
    e:btm
}

fn mkdir {|@args|
    if (==s $args[0] '-p') {
        set args = $args[1..]
        for i $args {
            os:makedirs $i
        }
        return
    }

    for i $args {
        os:makedir $i
    }
}

fn mv {|@args|
    if (> (count $args) 2) {
        try {
            var _ = (os:is-dir $args[-1])
        } catch e {
            fail $e
        }
        for i $args[0..-1] {
            os:move $i $args[-1]
        }
        return
    }

    os:move $args[0] $args[1]
}

fn rm {|@args|
    var recursive = $false
    if (==s $args[0] '-r') {
        set recursive = $true
        set args = $args[1..]
    }
    for i $args {
        if $recursive {
            os:removedirs $i
        } else {
            os:remove $i
        }
    }
}

{{ end }}

