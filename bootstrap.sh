#!/bin/sh

set -e

git submodule init
git submodule update

mkdir -p "$HOME"/.config/elvish/
ln -sf "$HOME"/.dotfiles/config/elvish/rc.elv "$HOME"/.config/elvish/rc.elv

elvish -c '
use epm
epm:install github.com/chlorm/elvish-dotfile-manager

use github.com/chlorm/elvish-dotfile-manager/dotfiles
dotfiles:install (get-env HOME)/.dotfiles/
'

exec elvish
exit $?

