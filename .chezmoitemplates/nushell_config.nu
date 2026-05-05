$env.PROMPT_COMMAND_RIGHT = ""

$env.config = {
    highlight_resolved_externals: true
    history: {
        # max_size: ?
        file_format: 'sqlite'
    }
    show_banner: false
    table: {
        mode: "thin"
    }
}

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'

$env.XDG_CONFIG_HOME = $env.APPDATA
$env.XDG_DATA_HOME = $env.LOCALAPPDATA
#$env.NU_HOME = ($env.XDG_DATA_HOME | path join "nu")
#$env.NU_LIB_DIRS = [
#    ($env.NU_HOME | path join "modules")
#]
#$env.PATH = (
#    $env.PATH
#        | split row (char esep)
#        | ....
#        | prepend $env.XDG_BIN_HOME
#        | uniq
#)

#use nu-stl/path

def --wrapped cat [...args: string] {
    try {
        ^bat ...$args
    } catch {
        ^cat ...$args
    }
}

alias "builtin ls" = ls
alias ls = eza --all --classify=auto --group-directories-first
#def --wrapped ls [...args: string] {
#    try {
#        ^eza ...$args
#    } catch {
#        try {
#            ^ls --color=auto ...$args
#        } catch {
#            # TODO: BSD ls
#            # TODO: builtin ls
#            ^ls ...$args
#        }
#    }
#}

def --wrapped vim [...args: string] {
    try {
        ^nvim ...$args
    } catch {
        try {
            ^vim ...$args
        } catch {
            ^vi ...$args
        }
    }
}
alias vi = vim

def rename [regex: string, repl: string, filename: string, -c] {
    let newfilename: string = echo $filename | str replace -r $regex $repl
    if $filename == $newfilename {
        return
    }
    print -e $"($filename) -> ($newfilename)"
    if $c {
        mv $filename $newfilename
    }
}

def renameall [regex: string, repl: string, -c] {
    for i in (glob --no-dir --no-symlink *) {
        rename $regex $repl $i -c
    }
}

# FIXME: make -c not require a value
def gal [...args: string, --cookies] {
    mut args = $args
    if $cookies {
        $args ++= [ '--cookies-from-browser' 'firefox' ]
    }
    print gallery-dl ...[
        '--retries' '1'
        '--sleep' '3'
        ...$args
    ]
}

def bkrid [] {
    let regex = '(-[A-Za-z0-9]{8})'
    for i in (glob --no-dir --no-symlink *) {
        let ext = $i | path parse | get extension
        let regexf = $"($regex)($ext)$"
        # FIXME
        if (re:match $regexf $i) {
            # FIXME
            let new = (re:replace $regexf $ext $i)
            print -e $"($i) -> ($new)"
            mv $i $new
        }
    }
}

def intro [f: path, -s: string = 'ph', --container: string = 'mp4'] {
    let time = {
        ab: '00:00:01.235'
        cw: '00:00:03.999'
        ph: '00:00:03.136'
        ex: '00:00:00.2'
    }
    let ext = $f | path parse | get extension
    let out = str replace -r $"($ext)$" $".($container)" $f
    ^ffmpeg ...[
        '-hide_banner'
        '-ss' ($time | get $s)
        '-i' $f
        '-c' 'copy'
        $"temp.($container)"
    ]
    rm $f
    mv $"temp.($container)" $out
}

def remux [f: path, --container: string = ''] {
    let ext = $f | path parse | get extension
    if $container == '' {
        let container = $ext
    } else {
        let container = $".($container)"
    }

    mut args = [ ]
    if $container == 'mp4' {
        $args ++= [ '-movflags' '+faststart' ]
    }

    let out = str replace -r $"($ext)$" $container $f
    ^ffmpeg ...[
        '-hide_banner'
        '-fflags' '+genpts'
        ...$args
        '-i' $f
        '-c' 'copy'
        '-map' '0'
        $"temp($container)"
    ]
    try {
        rm $f
    } catch {|e|
        rm $"temp($container)"
        # FIXME:
        error make {msg: $e.msg}
    }
    mv $"temp($container)" $out
}

def rr [f: path] {
    remux --container='mp4' $f
}

#def ffconcat {|out ...files|
#    def duration {|file|
#        let d = ^ffprobe ...[
#                '-v' 'error'
#                '-show_entries'
#                'format=duration'
#                '-of' 'default=noprint_wrappers=1:nokey=1'
#                $file
#        ]
#        return $d * 1000)
#    }
#
#    use os os_
#    use file file_
#
#    var concat = (os_:temp-file)
#    var concatn = $concat['name']
#    for i $files {
#        printf "file '%s'\n" (path:join (path:absolute '.') $i) >> $concatn
#    }
#
#    var chapter = (os_:temp-file)
#    var chaptern = $chapter['name']
#    printf ";FFMETADATA1\n\n" > $chaptern
#    var count = 1
#    var durTotal = 0
#    for i $files {
#        var dur = (duration $i)
#        printf "[CHAPTER]\nTIMEBASE=1/1000\nSTART=%s\nEND=%s\ntitle=Chapter %s\n\n" ^
#            (+ $durTotal 1) ^
#            (+ $durTotal $dur) ^
#            $count >> $chaptern
#        set count = (+ $count 1)
#        set durTotal = (+ $durTotal $dur)
#    }
#
#    try {
#        e:ffmpeg ^
#            '-hide_banner' ^
#            '-fflags' '+genpts' ^
#            '-f' 'concat' ^
#            '-safe' '0' ^
#            '-i' $concatn ^
#            '-i' $chaptern ^
#            '-map' '0' ^
#            '-map_metadata' '1' ^
#            '-c' 'copy' ^
#            $out
#    } catch e {
#        fail $e
#    } finally {
#        file_:close $concat
#    }
#}

def jdremux [] {
    let v: path = (glob '*.mp4').0
    mut a: path = (glob '*.m4a').0
    if ($a | is-empty) {
        $a = (glob '*.opus').0
    }
    let c: path = (glob '*.jpg').0
    mut d: string = ''
    try {
        $d = open (glob '*.txt').0
    } catch { }
    # FIXME:
    if $a == [ ] { fail }
    ^ffmpeg ...[
        -i $v
        -i $a
        -i $c
        -map 0:0
        -map 1:0
        -map 2:0
        -c copy
        -disposition:2 attached_pic
        -metadata comment=$d
        out.mp4
    ]
    try { rm $v } catch { }
    try { rm $a } catch { }
    try { rm $c } catch { }
    try {
        for i in (glob '*.srt') {
            rm $i
        }
    } catch { }
    try { rm ...(glob '*.txt') } catch { }
    mv 'out.mp4' $v
    rename '(.*) \([0-9]+p_[0-9]+fps_(?:H264|VP9)-[0-9]+kbit_[A-Z]+\)(.mp4)$' '$1$2' $v -c
}

def strip-all [] {
    #ffmpeg:fix-all
    renameall '^2' '' -c
}

def mpvc [v1: path v2: path] {
    ^mpv ...[
        '--lavfi-complex=[vid1][vid2]hstack[vo];[aid1][aid2]amix[ao]'
        $v1
        --external-file=$v2
    ]
}

#fn mpvc2 {|...videos|
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

def vmaf [reference: path, encode: path] {
    ^ffmpeg ...[
        '-hide_banner'
        '-i' $encode
        '-i' $reference
        '-lavfi' 'libvmaf=n_threads=16'
        '-f' 'null' '-'
    ]
}
def vmaf2 [reference: path, encode: path] {
    # Upstream example inputs are reversed when not explicitly defining the filter graph.
    # Confirmed upstream examples are wrong by generating multiple test encodes.
    ^ffmpeg ...[
        '-hide_banner'
        '-i' $reference
        '-i' $encode
        '-lavfi' 'libvmaf=n_threads=16'
        '-f' 'null' '-'
    ]
}
def vmaf3 [reference: path, encode: path] {
    # FIXME: Returns results below expected, probably missing filters for format conversion.
    ^ffmpeg ...[
        '-hide_banner'
        '-i' $reference
        '-i' $encode
        '-lavfi' '[0:v]setpts=PTS-STARTPTS[reference];[1:v]setpts=PTS-STARTPTS[encode];[encode][reference]libvmaf=n_threads=16'
        '-f' 'null' '-'
    ]
}
