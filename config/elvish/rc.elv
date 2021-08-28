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
epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
use github.com/chlorm/elvish-util-wrappers/btrfs
use github.com/chlorm/elvish-util-wrappers/git
use github.com/chlorm/elvish-util-wrappers/nix
use github.com/chlorm/elvish-util-wrappers/nm


# TODO: don't populate env vars inside rc
fn build-dir-list {
    epm:install &silent-if-installed=$true github.com/chlorm/elvish-xdg
    use github.com/chlorm/elvish-xdg/xdg-dirs
    xdg-dirs:populate-env

    xdgDirs = [ ]
    for i $xdg-dirs:XDG-VARS {
        xdgDirs = [ $@xdgDirs (get-env $i) ]
    }

    trashDirs = [
        (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/files/'
        (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/info/'
    ]

    customDirs = [
        (get-env HOME)'/Projects'
    ]

    kratosInitDirs = [
        $@xdgDirs
        $@trashDirs
        $@customDirs
    ]
    put (str:join ':' $kratosInitDirs)
}

set-env EMAIL 'cwopel@chlorm.net'
set-env GIT_NAME 'Cody Opel'
set-env GIT_EMAIL $E:EMAIL
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

set-env KRATOS_INIT_DOTFILES_DIRS $E:HOME'/.dotfiles'
set-env KRATOS_INIT_DIRS (build-dir-list)
epm:install &silent-if-installed=$true github.com/chlorm/kratos
use github.com/chlorm/kratos/kratos-init

edit:prompt = {
    styled (whoami) green
    styled-segment &dim=$true &fg-color=white '@'
    if (has-env SSH_CLIENT) {
        styled-segment (hostname) &bold=$true &fg-color=red
    } else {
        styled-segment &bold=$true &fg-color=white (hostname)
    }
    styled-segment &dim=$true &fg-color=white '['
    styled (tilde-abbr $pwd) red
    styled-segment &dim=$true &fg-color=white ']'
    styled-segment '〉' &bold=$true &fg-color=cyan
}
edit:rprompt = { }

# TODO: move to module
fn ls [@a]{
    try {
        e:ls '--color' $@a
    } except _ {
        try {
            e:ls '-G' $@a
        } except _ {
            e:ls $@a
        }
    }
}

fn settitle [title]{
    print "\033k"$title"\033\\"
}

edit:abbr['~t'] = ~/Projects/triton
E:NIX_PATH = 'nixpkgs='(get-env HOME)'/Projects/triton:nixos-config=/etc/nixos/configuration.nix:'

fn update-machines {
    nix:rebuild-system 'boot' --option binary-caches '""'
    nix:rebuild-envs --option binary-caches '""'
    nixos-closures = (nix:find-nixos-closures)
    nix-config-closures = [ (nix:find-nixconfig-closures) ]

    machines = [ ]
    hostname = (e:hostname)
    if (!=s $hostname 'miranova') {
        machines = [ $@machines 'miranova.aurora' ]
    }
    if (!=s $hostname 'Raenok') {
        machines = [ $@machines 'raenok.aurora' ]
    }
    for i $machines {
        nix:copy-closures $i $@nixos-closures $@nix-config-closures
    }
}

# Force plexmediaplayer to only use X.Org
fn plexmediaplayer {
    E:QT_QPA_PLATFORM=xcb exec plexmediaplayer
}
