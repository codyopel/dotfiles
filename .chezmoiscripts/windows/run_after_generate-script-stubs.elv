use github.com/chlorm/elvish-stl/env
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path

var SCRIPTS-DIR = (path:join (env:get 'APPDATA') 'scripts')
var STUB-DIR = (path:join (env:get 'LOCALAPPDATA') 'script-stubs')

var ELV = (search-external 'elvish')
for i (path:scandir $SCRIPTS-DIR)['files'] {
    var base = (path:basename $i)
    var stub = (path:join $STUB-DIR $base'.bat')
    if (not (os:exists $STUB-DIR)) {
        os:makedir $STUB-DIR
    }
    var p = (path:join $SCRIPTS-DIR $i)
    printf "@echo off\nstart /wait /b "$ELV" -norc "$p" %%*\nexit\n" > $stub
}
