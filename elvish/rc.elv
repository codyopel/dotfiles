# TODO:
# - Port dotfiles manager and write an updater
# - Port pager abstractions
# - Shell rc file starting elvish
# - Handle TERM environment variable
# - FreeBDSM ls color support
# - Color scheme wrapper around elvish-term-color
# - Wrapper for prompt themes
# - Automate setting EDITOR/VISUAL environment variables
# - GOPATH / add to PATH
# - HIGHDPI
# - Port nmcli wrapper (e.g. wifi)
# - Port pulseaudio wrapper (e.g. volume)
# - Port triton wrapper
# - Port btrfs wrapper
# - Port battery wrapper
# - Port user-agent handling
# - Port ssh key management
# - Port sprunge alias
# - Use another or port Git wrapper
# - Password prompt
# - Y/N prompt
# - PATH manipulation?
#
# Wrappers: (abstract platform specifics)
# - mkdir
# - ln
# - rm
# - touch
# - Upper/Lower casing strings
# - os kernel/os linux
# - math (mode/round)
# - structured logging?
# - cpu
# - argument parsing

# Aliases
# alias nixpaste="curl -F 'text=<-' http://nixpaste.noip.me"

use epm
epm:install &silent-if-installed=$true github.com/chlorm/kratos
#use github.com/chlorm/kratos/kratos
use github.com/chlorm/kratos/kratos-init

edit:abbr['~t'] = ~/Projects/triton

E:EMAIL = 'codyopel@gmail.com'

E:DOTFILES_REPO = 'https://github.com/codyopel/dotfiles.git'

E:GIT_NAME = 'Cody Opel'
E:GIT_EMAIL = $E:EMAIL

if ?(has-env SSH_ASKPASS >/dev/null) {
  unset-env SSH_ASKPASS
}

E:EDITOR = 'vim'
E:VISUAL = 'vim'

fn ls [@a]{ e:ls --color $@a }

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
  edit:styled '〉 ' 'bold;cyan'
}
edit:rprompt = { }

fn triton-rebuild [target @args]{
  sudo nixos-rebuild $target \
    -I 'nixos-config=/etc/nixos/configuration.nix' \
    -I 'nixpkgs='$E:HOME'/Projects/triton' \
    $@args
}

fn mssh {
  sudo sshfs \
    -o allow_other cwopel@10.3.1.4:/home/cwopel ~/tmnt
}

fn beetu [@args]{
  beet -c $E:HOME'/.config/beets/config-unconfirmed.yaml' $@args
}

fn youtube [@args]{
  youtube-dl -f "bestvideo+bestaudio" --no-check-certificate \
    --prefer-insecure --console-title $@args
}

fn dotfiles-dir { put $E:HOME'/.dotfiles' }

# Test completers
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/git
use github.com/xiaq/edit.elv/compl/go
go:apply
