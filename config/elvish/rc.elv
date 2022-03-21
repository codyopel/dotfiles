# TODO:
# - Handle TERM environment variable
# - HIGHDPI
# - PATH manipulation?
# LOPRIO:
# - math (mode)
# - Password prompt
# - Y/N prompt
# - Wrapper for prompt themes
# ALIASES:
# - sprunge="curl -F 'sprunge=<-' http://sprunge.us"


use epm
use str
epm:install &silent-if-installed=$true github.com/chlorm/elvish-stl
epm:install &silent-if-installed=$true github.com/chlorm/elvish-term
epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-term/ansi
# CLI helpers
use github.com/chlorm/elvish-util-wrappers/btrfs
use github.com/chlorm/elvish-util-wrappers/git
use github.com/chlorm/elvish-util-wrappers/nix
use github.com/chlorm/elvish-util-wrappers/nm


# TODO: don't populate env vars inside rc
fn build-dir-list {
    epm:install &silent-if-installed=$true github.com/chlorm/elvish-xdg
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

    put (str:join ':' $initDirs)
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
epm:install &silent-if-installed=$true github.com/chlorm/kratos
use github.com/chlorm/kratos/kratos-init

set edit:prompt = {
    styled (e:whoami) green
    styled-segment &dim=$true &fg-color=white '@'
    if (has-env SSH_CLIENT) {
        styled-segment (platform:hostname) &bold=$true &fg-color=red
    } else {
        styled-segment &bold=$true &fg-color=white (platform:hostname)
    }
    styled-segment &dim=$true &fg-color=white '['
    styled (tilde-abbr $pwd) red
    styled-segment &dim=$true &fg-color=white ']'
    styled-segment '〉' &bold=$true &fg-color=cyan
}
set edit:rprompt = { }

# TODO: move to module
fn ls {|@a|
    try {
        e:ls '--color' $@a
    } catch _ {
        try {
            e:ls '-G' $@a
        } catch _ {
            e:ls $@a
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

# Force plexmediaplayer to only use X.Org
fn plexmediaplayer {
    tmp E:QT_QPA_PLATFORM = xcb; exec plexmediaplayer
}
}
