#!/usr/bin/env elvish
# vim: ft=elvish

for i [ (range 0 16) ] {
    var x = $i
    set i = (+ 30 $i)
    if (> $i 37) {
        set i = (+ 52 $i)
    }
    var a = ''
    if (> $i 89) { set a = ' ' }
    print "\x1b["(to-string $i)"m\a"(to-string $x)":▉"$i$a"\x1b[0m\a "
}
print "\n"
for i [ (range 0 16) ] {
    var x = $i
    set i = (+ 40 $i)
    if (> $i 47) {
        set i = (+ 52 $i)
    }
    print "\x1b["(to-string $i)"m\a"(to-string $x)": "$i"\x1b[0m\a "
}
