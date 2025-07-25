#!/usr/bin/env elvish


use github.com/chlorm/elvish-ssh/conf
use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/path


var authKeysDir = (path:join $conf:DIR 'authorized_keys.d')
var pubKeyFiles = (path:scandir $authKeysDir)
var pubKeys = [ ]
for pubKey $pubKeyFiles['files'] {
    set pubKeys = [
        $@pubKeys
        (io:read (path:join $pubKeyFiles['root'] $pubKey))
    ]
}
conf:populate-authorized-keys $@pubKeys
try {
    conf:set-permissions
} catch e {
    echo $e >&2
}
