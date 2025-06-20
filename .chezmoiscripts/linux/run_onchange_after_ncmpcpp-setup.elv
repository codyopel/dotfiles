#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-xdg/xdg-dirs


os:makedirs (xdg-dirs:cache-home)'/ncmpcpp/lyrics'
