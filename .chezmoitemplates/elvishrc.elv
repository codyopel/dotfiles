use epm
epm:install &silent-if-installed=$true github.com/chlorm/elvish-stl
epm:install &silent-if-installed=$true github.com/chlorm/elvish-term
epm:install &silent-if-installed=$true github.com/chlorm/elvish-util-wrappers
epm:install &silent-if-installed=$true github.com/chlorm/elvish-xdg
epm:install &silent-if-installed=$true github.com/chlorm/kratos

use github.com/chlorm/elvish-stl/env
use github.com/chlorm/elvish-stl/exec
use github.com/chlorm/elvish-stl/ini
use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/list
use github.com/chlorm/elvish-stl/map
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-stl/proc
use github.com/chlorm/elvish-stl/re
use github.com/chlorm/elvish-stl/str
use github.com/chlorm/elvish-term/ansi
use github.com/chlorm/elvish-term/osc
use github.com/chlorm/elvish-xdg/xdg-dirs
# CLI helpers
use github.com/chlorm/elvish-git/filter-repo
use github.com/chlorm/elvish-git/status
use github.com/chlorm/elvish-util-wrappers/audio
#use github.com/chlorm/elvish-util-wrappers/btrfs
use github.com/chlorm/elvish-util-wrappers/ffmpeg
#use github.com/chlorm/elvish-util-wrappers/nix
use github.com/chlorm/elvish-util-wrappers/nm
use github.com/chlorm/elvish-util-wrappers/yt-dlp


################################################################################
################################### Init #######################################
################################################################################


set-env 'LANG' 'C.UTF-8'
set-env 'DONT_PROMPT_WSL_INSTALL' 1
set-env 'EMAIL' 'cwopel@chlorm.net'
set-env 'GIT_NAME' 'Cody Opel'
set-env 'GIT_EMAIL' (get-env 'EMAIL')

# TODO: don't populate env vars inside rc
fn build-dir-list {
    xdg-dirs:populate-env

    var initDirs = [ ]
    # XDG Directories
    for i $xdg-dirs:XDG-VARS {
        set initDirs = [ $@initDirs (get-env $i) ]
    }

    # Linux trash directories
    if $platform:is-linux {
        set initDirs = [
            $@initDirs
            (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/files/'
            (get-env $xdg-dirs:XDG-DATA-HOME)'/trash/info/'
        ]
    }

    # Custom personal directories
    set initDirs = [
        $@initDirs
        (path:join (path:home) 'Projects')
    ]

    put (str:join $env:DELIMITER $initDirs)
}

set-env 'KRATOS_INIT_DIRS' (build-dir-list)
use github.com/chlorm/kratos/kratos-init


################################################################################
######################### Aliases/Helper Functions #############################
################################################################################


fn cat {|@args|
    try {
        e:bat $@args
    } catch _ {
        try {
            e:cat $@args
        } catch _ {
            for i $args {
                var f = (io:read $i)
                echo $f
            }
        }
    }
}

fn ls {|@a|
    try {
        # FIXME: Remove -a once issue is fixed upstream
        # https://github.com/eza-community/eza/issues/1220
        e:eza '-a' $@a 2>$os:NULL
    } catch _ {
        try {
            e:ls '--color' $@a 2>$os:NULL
        } catch _ {
            try {
                e:ls '-G' $@a 2>$os:NULL
            } catch _ {
                e:ls $@a
            }
        }
    }
}

fn sl {
    put *
}

fn vi {|@a|
    try {
        e:nvim $@a
    } catch _ {
        try {
            e:vim $@a
        } catch _ {
            e:vi $@a
        }
    }
}
fn vim {|@a| vi $@a }

fn clear { osc:clear }

fn settitle {|title|
    printf "%sk%s%s" $ansi:ESC $title $ansi:ST
}

fn yt {|@args| yt-dlp:youtube $@args }
fn yy {|@args| yt-dlp:stream-download $@args }
fn yd {|@args| yt-dlp:stream-watcher $@args }
fn ym { yt-dlp:streams-manager }

set edit:abbr['~t'] = ~/Projects/triton
set E:NIX_PATH = 'nixpkgs='(get-env HOME)'/Projects/triton:nixos-config=/etc/nixos/configuration.nix:'

fn update-machines {
    nix:rebuild-system 'boot' --option binary-caches '""'
    nix:rebuild-envs --option binary-caches '""'
    var nixos-closures = (nix:find-nixos-closures)
    var nix-config-closures = [ (nix:find-nixconfig-closures) ]

    var machines = [ ]
    var hostname = (platform:hostname)
    if (!=s $hostname 'miranova') {
        set machines = [ $@machines 'miranova.aurora' ]
    }
    if (!=s $hostname 'Raenok') {
        set machines = [ $@machines 'raenok.aurora' ]
    }
    for i $machines {
        nix:copy-closures $i $@nixos-closures $@nix-config-closures
    }
}

# Force plexmediaplayer to only use X.Org
fn plexmediaplayer {
    tmp E:QT_QPA_PLATFORM = xcb; exec plexmediaplayer
}

fn rename {|regex repl file &c=$false|
    var newfile = (re:replace $regex $repl $file)
    if (==s $file $newfile) {
        return
    }
    echo $file' -> '$newfile
    if $c {
        os:move $file $newfile
    }
}

fn renameall {|regex repl &c=$false|
    for i [ (put *) ] {
        rename &c=$c $regex $repl $i
    }
}

fn gal {|@args &c=$false|
    if $c {
        set args = [
            '--cookies-from-browser' 'firefox'
            $@args
        ]
    }
    e:gallery-dl ^
        '--retries' '1' ^
        '--sleep' '3' ^
        $@args
}

fn bkrid {
    var regex = '(-[A-Za-z0-9]{8})'
    for i [ (put *) ] {
        var ext = (path:ext $i)
        var regexf = $regex$ext'$'
        if (re:match $regexf $i) {
            var new = (re:replace $regexf $ext $i)
            echo $i' -> '$new
            os:move $i $new
        }
    }
}

fn intro {|f &s='ph' &container='mp4'|
    var time = [
        &ab='00:00:01.235'
        &cw='00:00:03.999'
        &ph='00:00:03.136'
        &ex='00:00:00.2'
    ]
    var ext = (path:ext $f)
    var out = (re:replace $ext'$' '.'$container $f)
    e:ffmpeg ^
        '-hide_banner' ^
        '-ss' $time[$s] ^
        '-i' $f ^
        '-c' 'copy' ^
        'temp.'$container
    os:remove $f
    os:move 'temp.'$container $out
}

fn remux {|f &container=''|
    var ext = (path:ext $f)
    if (==s $container '') {
        set container = $ext
    } else {
        set container = '.'$container
    }

    var args = []
    if (==s $container 'mp4') {
        set args = [ '-movflags' '+faststart' ]
    }

    var out = (re:replace $ext'$' $container $f)
    e:ffmpeg ^
        '-hide_banner' ^
        '-fflags' '+genpts' ^
        $@args ^
        '-i' $f ^
        '-c' 'copy' ^
        '-map' '0' ^
        'temp'$container
    try {
        os:remove $f
    } catch e {
        os:remove 'temp'$container
        fail $e
    }
    os:move 'temp'$container $out
}

fn rr {|f|
    remux &container='mp4' $f
}

fn ffconcat {|out @files|
    fn duration {|file|
        var d = (
            e:ffprobe ^
                '-v' 'error' ^
                '-show_entries' ^
                'format=duration' ^
                '-of' 'default=noprint_wrappers=1:nokey=1' ^
                $file
        )
        put (* $d 1000)
    }

    use os os_
    use file file_

    var concat = (os_:temp-file)
    var concatn = $concat['name']
    for i $files {
        printf "file '%s'\n" (path:join (path:absolute '.') $i) >> $concatn
    }

    var chapter = (os_:temp-file)
    var chaptern = $chapter['name']
    printf ";FFMETADATA1\n\n" > $chaptern
    var count = 1
    var durTotal = 0
    for i $files {
        var dur = (duration $i)
        printf "[CHAPTER]\nTIMEBASE=1/1000\nSTART=%s\nEND=%s\ntitle=Chapter %s\n\n" ^
            (+ $durTotal 1) ^
            (+ $durTotal $dur) ^
            $count >> $chaptern
        set count = (+ $count 1)
        set durTotal = (+ $durTotal $dur)
    }

    try {
        e:ffmpeg ^
            '-hide_banner' ^
            '-fflags' '+genpts' ^
            '-f' 'concat' ^
            '-safe' '0' ^
            '-i' $concatn ^
            '-i' $chaptern ^
            '-map' '0' ^
            '-map_metadata' '1' ^
            '-c' 'copy' ^
            $out
    } catch e {
        fail $e
    } finally {
        file_:close $concat
    }
}

fn jdremux {
    var v = (put *.mp4)
    var a = $nil
    try {
        set a = (put *.m4a)
    } catch _ {
        set a = (put *.opus)
    }
    var c = (put *.jpg)
    var d = ''
    try {
        set d = (slurp < *.txt)
    } catch _ { }
    if (eq $a $nil) { fail }
    e:ffmpeg ^
        -i $v ^
        -i $a ^
        -i $c ^
        -map 0:0 ^
        -map 1:0 ^
        -map 2:0 ^
        -c copy ^
        -disposition:2 attached_pic ^
        -metadata comment=$d ^
        out.mp4
    try { os:remove $v } catch _ { }
    try { os:remove $a } catch _ { }
    try { os:remove $c } catch _ { }
    try {
        for i [ (put *.srt) ] {
            os:remove $i
        }
    } catch _ { }
    try { os:remove (put *.txt) } catch _ { }
    os:move out.mp4 $v
    rename '(.*) \([0-9]+p_[0-9]+fps_(?:H264|VP9)-[0-9]+kbit_[A-Z]+\)(.mp4)$' '$1$2' $v &c
}

fn strip-all {
    ffmpeg:fix-all
    renameall '^2' '' &c
}

fn aniname {|&c=$false &codec=''|
    var group = '\[([a-zA-Z0-9_ -]+)\]'
    var sep = '(?: |\.)'
    var sepl = '(?: - | |\.-\.|\.|_-_|_)'
    var title = '([a-zA-Z0-9!\.,_\(\) -]+?)'
    var ep = '(S[0-9]{2}E[0-9]{2}|(?:E|)[0-9]{2})'
    var eptitle = '(?:'$sepl'([a-zA-Z0-9!''\. -]+)|)'
    var ext = '\.(mkv|mp4)'
    renameall &c=$c ^
        '^'$group$sep$title$sepl$ep$eptitle$sep'.*'$ext'$' ^
        '$2.$3.$4.'$codec'mediainfo-$1.$5'
}

fn mpvc {|v1 v2|
    e:mpv --lavfi-complex="[vid1][vid2]hstack[vo];[aid1][aid2]amix[ao]" $v1 --external-file=$v2
}

#fn mpvc2 {|@videos|
#    use math
#    var rowsize = (math:sqrt (counts $videos))
#    # Round up to nearest integer
#    if (!= $rowsize (math:trunc $rowsize)) {
#        set rowsize = (+ (math:trunc $rowsize) 1)
#    }
#
#    var columns = [ ]
#    var rows = [ ]
#    for row [ () ] {
#
#    }
#
#    e:mpv --lavfi-complex="[vid1][vid2]hstack[vo];[aid1][aid2]amix[ao]" $v1 --external-file=$v2
#}

fn vmaf {|reference encode|
    e:ffmpeg ^
        '-hide_banner' ^
        '-i' $encode ^
        '-i' $reference ^
        '-lavfi' 'libvmaf=n_threads=16' ^
        '-f' 'null' '-'
}
fn vmaf2 {|reference encode|
    # Upstream example inputs are reversed when not explicitly defining the filter graph.
    # Confirmed upstream examples are wrong by generating multiple test encodes.
    e:ffmpeg '-hide_banner' '-i' $reference '-i' $encode '-lavfi' 'libvmaf=n_threads=16' '-f' 'null' '-'
}

fn vmaf3 {|reference encode|
    # FIXME: Returns results below expected, probably missing filters for format conversion.
    e:ffmpeg '-hide_banner' ^
        '-i' $reference ^
        '-i' $encode ^
        '-lavfi' '[0:v]setpts=PTS-STARTPTS[reference];[1:v]setpts=PTS-STARTPTS[encode];[encode][reference]libvmaf=n_threads=16' ^
        '-f' 'null' '-'
}

{{ if .isWindows }}

# TODO: -r
fn cp {|@args|
    if (> (count $args) 2) {
        try {
            var _ = (os:is-dir $args[-1])
        } catch e {
            fail $e
        }
        for i $args[0..-1] {
            os:copy $i $args[-1]
        }
        return
    }

    os:copy $args[0] $args[1]
}

fn htop {
    e:btm
}

fn mkdir {|@args|
    if (==s $args[0] '-p') {
        set args = $args[1..]
        for i $args {
            os:makedirs $i
        }
        return
    }

    for i $args {
        os:makedir $i
    }
}

fn mv {|@args|
    if (> (count $args) 2) {
        try {
            var _ = (os:is-dir $args[-1])
        } catch e {
            fail $e
        }
        for i $args[0..-1] {
            os:move $i $args[-1]
        }
        return
    }

    os:move $args[0] $args[1]
}

fn rm {|@args|
    var recursive = $false
    if (==s $args[0] '-r') {
        set recursive = $true
        set args = $args[1..]
    }
    for i $args {
        if $recursive {
            os:removedirs $i
        } else {
            os:remove $i
        }
    }
}

{{ end }}

