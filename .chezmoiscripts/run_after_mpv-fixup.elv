#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-stl/str


var MPVDIR = (path:join '.config' 'mpv' 'scripts')
if $platform:is-windows {
    set MPVDIR = (path:join 'AppData' 'Roaming' 'mpv' 'scripts')
}

fn rename-plugin {|dir plugin|
    var m = (path:join $MPVDIR $dir 'main.lua')
    if (not (os:exists $m)) {
        printf "require('%s')\n" $plugin > $m
    }
}

fn fix-vr-reversal-resolution-scale {
    var m = (path:join $MPVDIR 'vr-reversal' '360plugin.lua')
    if (os:exists $m) {
        var t = (io:open $m)
        set t = (str:replace 'local res  = 1.0' 'local res  = 10.0' $t)
        printf "%s" $t > $m
    }
}

rename-plugin 'delete-current-file' 'delete_current_file'
rename-plugin 'sub-select' 'sub-select'
rename-plugin 'thumbfast' 'thumbfast'
rename-plugin 'vr-reversal' '360plugin'
fix-vr-reversal-resolution-scale
