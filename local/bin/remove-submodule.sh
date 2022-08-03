#!/bin/sh

submodule="$1"

git submodule deinit "$submodule"
git rm "$submodule"
git rm --cached "$submodule" || :
rm -rvf .git/modules/"$submodule"
