#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-xdg/xdg-dirs


var cache = (xdg-dirs:cache-home)'/mpd'
os:makedirs $cache
os:chmod 700 $cache
os:touch $cache'/log'
os:touch $cache'/state'
os:touch $cache'/sticker'
var config = (xdg-dirs:config-home)'/mpd'
os:makedirs $config
os:chmod 700 $config
var runtime = (xdg-dirs:runtime-dir)'/mpd'
os:makedirs $runtime
os:chmod 700 $runtime
var state = (xdg-dirs:state-home)'/mpd'
os:makedirs $state
os:chmod 700 $state
os:touch $state'/database'

e:systemctl --user enable mpd.socket
