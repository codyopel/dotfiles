# TODO:
# - Handle TERM environment variable
# - HIGHDPI
# - Port pulseaudio wrapper (e.g. volume)
# - PATH manipulation?
# - GOPATH / add to PATH
# - https://github.com/chlorm/kratos/tree/c82657c9565ce041ade093c473c3f6d0b25be0ad/plugins/golang
#

# LOPRIO:
# - Upper/Lower casing strings
# - math (mode)
# - structured logging?
# - cpu
# - argument parsing
# - Password prompt
# - Y/N prompt
# - Wrapper for prompt themes


# Aliases
# alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"


use str


edit:abbr['~t'] = ~/Projects/triton

E:EMAIL = 'cwopel@chlorm.net'

E:DOTFILES_REPO = 'https://github.com/codyopel/dotfiles.git'
E:KRATOS_INIT_DOTFILES_DIRS = $E:HOME'/.dotfiles'

E:GIT_NAME = 'Cody Opel'
E:GIT_EMAIL = $E:EMAIL

if ?(has-env 'SSH_ASKPASS' >/dev/null) {
  unset-env 'SSH_ASKPASS'
}

E:NIX_PATH = 'nixpkgs='(get-env HOME)'/Projects/triton:nixos-config=/etc/nixos/configuration.nix:'


use github.com/chlorm/elvish-xdg/xdg
xdg:populate-env-vars

local:xdg-dirs = [ ]
for local:i [ (keys $xdg:xdg-vars) ] {
  if (not (eq $xdg:xdg-vars[$i] $nil)) {
    xdg-dirs = [ $@xdg-dirs (get-env $i) ]
  }
}

local:trash-dirs = [
  (get-env XDG_DATA_HOME)'/trash/files/'
  (get-env XDG_DATA_HOME)'/trash/info/'
]

local:custom-dirs = [
  (get-env HOME)'/Projects'
]

kratos-init-dirs = [
  $@xdg-dirs
  $@trash-dirs
  $@custom-dirs
]
set-env KRATOS_INIT_DIRS (str:join ':' $kratos-init-dirs)

use epm
epm:install &silent-if-installed=$true github.com/chlorm/kratos
#use github.com/chlorm/kratos/kratos
use github.com/chlorm/kratos/kratos-init
epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
use github.com/chlorm/elvish-util-wrappers/btrfs
use github.com/chlorm/elvish-util-wrappers/nix
use github.com/chlorm/elvish-util-wrappers/nm

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

fn ls [@a]{ e:ls '--color' $@a }

# FreeBSD
E:CLICOLOR = 1
E:LSCOLORS = 'ExGxFxdxCxDhDxaBadaCeC'

fn settitle [title]{
  print "\033k"$title"\033\\"
}

fn update-machines {
  nix:rebuild-system 'boot' --option binary-caches '""'
  nix:rebuild-envs --option binary-caches '""'
  nixos-closures = (nix:find-nixos-closures)
  nix-config-closures = [ (nix:find-nixconfig-closures) ]

  local:machines = [ ]
  local:hostname = (e:hostname)
  if (!=s $hostname 'miranova') {
    machines = [ $@machines 'miranova.aurora' ]
  }
  if (!=s $hostname 'Raenok') {
    machines = [ $@machines 'raenok.aurora' ]
  }
  for local:i $machines {
    nix:copy-closures $i $@nixos-closures $@nix-config-closures
  }
}

# Force plexmediaplayer to only use X.Org
fn plexmediaplayer {
  E:QT_QPA_PLATFORM=xcb exec plexmediaplayer
}

