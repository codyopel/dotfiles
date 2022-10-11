use epm
epm:install &silent-if-installed=$true github.com/chlorm/elvish-stl
use github.com/chlorm/elvish-stl/env
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-stl/str

# TODO: don't populate env vars inside rc
fn build-dir-list {
    epm:install &silent-if-installed=$true github.com/chlorm/elvish-xdg
    use github.com/chlorm/elvish-xdg/xdg-dirs
    xdg-dirs:populate-env

    var initDirs = [ ]

    # XDG Directories
    for i $xdg-dirs:XDG-VARS {
        set initDirs = [ $@initDirs (env:get $i) ]
    }

    # Custom personal directories
    set initDirs = [
        $@initDirs
        (path:join (path:home) 'Projects')
        (path:join (path:home) 'Workspaces')
    ]

    str:join $env:DELIMITER $initDirs
}

env:set EMAIL 'cwopel@chlorm.net'
env:set GIT_NAME 'Cody Opel'
env:set GIT_EMAIL (env:get 'EMAIL')
# FIXME: this will eventually be multiple repos and need some other format.
env:set DOTFILES_REPO 'https://github.com/codyopel/dotfiles.git'
env:set DOTFILE_REPOS '{
    # FIXME: need to either make this just an array, have multiple top-level
    #        keys, or a generic key name.  Would be ideal to support archives
    #        and other formats at some point.
    "repos": [
        "https://github.com/codyopel/dotfiles",
        "https://github.com/chlorm/dotfiles-keyring-services",
        "https://github.com/chlorm/dotfiles-vim"
    ]
}'

env:set KRATOS_INIT_DOTFILES_DIRS (path:join (path:home) '.dotfiles')
env:set KRATOS_INIT_DIRS (build-dir-list)
epm:install &silent-if-installed=$true github.com/chlorm/kratos
use github.com/chlorm/kratos/kratos-init

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

fn vi {|@a|
    e:nvim $@a
}
fn vim {|@a|
    e:nvim $@a
}

# CLI helpers
#epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
#use github.com/chlorm/elvish-util-wrappers/git

set edit:abbr['~t'] = ~/Projects/triton
env:set NIX_PATH ^
    'nixpkgs='(path:home)'/Workspaces/triton/triton:nixos-config=/etc/nixos/configuration.nix:'

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

fn rename {|repl new file|
    use github.com/chlorm/elvish-stl/os
    use github.com/chlorm/elvish-stl/re
    var newfile = (re:replace $repl $new $file)
    if (==s $file $newfile) {
        return
    }
    echo $file '->' $newfile >&2
    os:move $file $newfile
}

fn renameall {|repl new|
    for i [(put *)] {
        rename $repl $new $i
    }
}
