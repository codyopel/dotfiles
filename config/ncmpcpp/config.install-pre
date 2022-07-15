#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-xdg/xdg-dirs


if $platform:is-unix {
    os:makedirs (xdg-dirs:cache-home)'/ncmpcpp/lyrics'
}
