#!/usr/bin/env elvish


use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-util-wrappers/firefox


var FIREFOX-DIR = (firefox:get-dir)

if (not (os:exists $FIREFOX-DIR)) {
    echo 'firefox-setup.elv: Nothing to do' >&2
    exit
}

var PROFILE-DIRS = (firefox:get-profile-dirs)

fn user-chrome {
    var userChrome = 'userChrome.css'
    var userChromePath = (path:join $FIREFOX-DIR $userChrome)
    if (os:exists $userChromePath) {
        for i $PROFILE-DIRS {
            var profileUserChromePath = (path:join $i $userChrome)
            if (os:exists $profileUserChromePath) {
                os:remove $profileUserChromePath
            }
            os:copy $userChromePath $profileUserChromePath
        }
    }
}

if (firefox:is-running) {
    echo 'Cannot apply firefox config changes while firefox is running' >&2
    exit
}

user-chrome

# TODO:
# arkenfox
# betterfox
# user-overrides
