#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-xdg/xdg-dirs


if (not (has-external 'ncmpcpp')) {
    echo 'ncmpcpp-setup: Nothing to do' >&2
    exit
}

os:makedirs (xdg-dirs:cache-home)'/ncmpcpp/lyrics'
