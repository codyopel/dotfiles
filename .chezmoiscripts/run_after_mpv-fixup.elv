#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform


var mpvDir = '.config/mpv/scripts'
if $platform:is-windows {
    set mpvDir = 'AppData/Roaming/mpv/scripts'
}

fn rename-plugin {|dir plugin|
    if (and (os:exists $mpvDir'/'$dir'/main.lua') ^
            (os:exists $mpvDir'/'$dir'/'$plugin'.lua')) {
        os:remove $mpvDir'/'$dir'/main.lua'
    }

    if (os:exists $mpvDir'/'$dir'/'$plugin'.lua') {
        os:move $mpvDir'/'$dir'/'$plugin'.lua' $mpvDir'/'$dir'/main.lua'
    }
}

rename-plugin 'thumbfast' 'thumbfast'
rename-plugin 'vr-reversal' '360plugin'
