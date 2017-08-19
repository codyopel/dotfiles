" Copyright (c) 2015-2016, Cody Opel <codyopel@gmail.com>.
"
" Use of this source code is governed by the terms of the
" BSD-3 license.  A copy of the license can be found in
" the `LICENSE' file in the top level source directory.

highlight clear
syntax reset
let g:colors_name="monokai"

" Terminal color definitions
let s:cterm00 = "00"
let s:cterm01 = "01"
let s:cterm02 = "02"
let s:cterm03 = "03"
let s:cterm04 = "04"
let s:cterm05 = "05"
let s:cterm06 = "06"
let s:cterm07 = "07"
let s:cterm08 = "08"
let s:cterm09 = "09"
let s:cterm10 = "04" " dupe
let s:cterm11 = "05" " dupe
let s:cterm12 = "06" " dupe
let s:cterm13 = "07" " dupe
let s:cterm14 = "08" " dupe
let s:cterm15 = "15"

" GUI color definitions
let s:gui00 = "272822"
let s:gui01 = "f92672"
let s:gui02 = "a6e22e"
let s:gui03 = "e6db74"
let s:gui04 = "2196e8"
let s:gui05 = "ae81ff"
let s:gui06 = "66d9ef"
let s:gui07 = "f8f8f2"
let s:gui08 = "75715e"
let s:gui09 = "fd971f"
let s:gui10 = "2196e8" " 04
let s:gui11 = "ae81ff" " 05
let s:gui12 = "66d9ef" " 06
let s:gui13 = "f8f8f2" " 07
let s:gui14 = "75715e" " 08
let s:gui15 = "f8f8f0"

" TODO: neovim support

" Highlighting function
fun! <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg != ""
    exec "highlight " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "highlight " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "highlight " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "highlight " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "highlight " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
  if a:guisp != ""
    exec "highlight " . a:group . " guisp=#" . a:guisp
  endif
endfun

call <sid>hi("Normal", s:gui15, s:gui00, s:cterm15, "none", "", "")
call <sid>hi("Cursor", s:gui15, s:gui15, s:cterm15, s:cterm15, "bold", "")
call <sid>hi("CursorLine", "", s:gui00, "", s:cterm00, "none", "")
call <sid>hi("CursorLineNr", s:gui15, "", s:cterm15, "", "none", "")  " FIXME: move to line numbers
call <sid>hi("Boolean", s:gui05, "", s:cterm05, "", "", "")
highlight Character ctermfg=3
call <sid>hi("Number", s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("String", s:gui03, "", s:cterm03, "", "", "")
highlight Conditional ctermfg=1
highlight Constant ctermfg=6 cterm=bold
highlight Debug ctermfg=225 cterm=bold
highlight Define ctermfg=14
highlight Delimiter ctermfg=241

highlight DiffAdd ctermbg=24
highlight DiffChange ctermfg=114 ctermbg=239
highlight DiffDelete ctermfg=162 ctermbg=53
highlight DiffText                    ctermbg=102 cterm=bold

highlight Directory       ctermfg=10               cterm=bold
highlight Error           ctermfg=219 ctermbg=89
call <sid>hi("ErrorMsg", s:gui00, s:gui09, s:cterm00, s:cterm09, "", "")
highlight Exception       ctermfg=10               cterm=bold
highlight Float           ctermfg=5
highlight FoldColumn      ctermfg=67  ctermbg=16
highlight Folded          ctermfg=67  ctermbg=16
highlight Function        ctermfg=10
highlight Identifier      ctermfg=10              cterm=none
highlight Ignore          ctermfg=244 ctermbg=232
highlight IncSearch       ctermfg=193 ctermbg=16

highlight keyword         ctermfg=1
highlight Label           ctermfg=229               cterm=none
highlight Macro           ctermfg=193
highlight SpecialKey      ctermfg=14

highlight MatchParen      ctermfg=233  ctermbg=9 cterm=bold
highlight ModeMsg         ctermfg=229
highlight MoreMsg         ctermfg=229
highlight Operator        ctermfg=3

" complete menu
highlight Pmenu           ctermfg=14  ctermbg=16
highlight PmenuSel        ctermfg=255 ctermbg=242
highlight PmenuSbar                   ctermbg=232
highlight PmenuThumb      ctermfg=14

highlight PreCondit       ctermfg=10               cterm=bold
highlight PreProc         ctermfg=9
highlight Question        ctermfg=14
highlight Repeat          ctermfg=15
highlight Search          ctermfg=0   ctermbg=222   cterm=NONE

" marks column
highlight SignColumn      ctermfg=10 ctermbg=235
highlight SpecialChar     ctermfg=1
highlight SpecialComment  ctermfg=245               cterm=bold
highlight Special         ctermfg=14
if has("spell")
  highlight SpellBad                ctermbg=52
  highlight SpellCap                ctermbg=17
  highlight SpellLocal              ctermbg=17
  highlight SpellRare  ctermfg=none ctermbg=none  cterm=reverse
endif
highlight Statement       ctermfg=1
highlight StatusLine      term=reverse ctermfg=233 ctermbg=15
set laststatus=2
highlight StatusLineNC    ctermfg=244 ctermbg=232
highlight StorageClass    ctermfg=9
highlight Structure       ctermfg=14
highlight Tag             ctermfg=1
highlight Title           ctermfg=166
highlight Todo            ctermfg=231 ctermbg=232   cterm=bold

highlight Typedef         ctermfg=14
highlight Type            ctermfg=14                cterm=none
highlight Underlined      ctermfg=244               cterm=underline

highlight VertSplit       ctermfg=244 ctermbg=232   cterm=bold
highlight VisualNOS                   ctermbg=238
highlight Visual                      ctermbg=235
highlight WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
highlight WildMenu        ctermfg=14  ctermbg=16

highlight Comment         ctermfg=8
highlight CursorColumn                ctermbg=236
highlight ColorColumn                 ctermbg=236
highlight LineNr          ctermfg=8 ctermbg=233
highlight NonText         ctermfg=8

highlight SpecialKey      ctermfg=8

unlet s:cterm00
unlet s:cterm01
unlet s:cterm02
unlet s:cterm03
unlet s:cterm04
unlet s:cterm05
unlet s:cterm06
unlet s:cterm07
unlet s:cterm08
unlet s:cterm09
unlet s:cterm10
unlet s:cterm11
unlet s:cterm12
unlet s:cterm13
unlet s:cterm14
unlet s:cterm15

unlet s:gui00
unlet s:gui01
unlet s:gui02
unlet s:gui03
unlet s:gui04
unlet s:gui05
unlet s:gui06
unlet s:gui07
unlet s:gui08
unlet s:gui09
unlet s:gui10
unlet s:gui11
unlet s:gui12
unlet s:gui13
unlet s:gui14
unlet s:gui15

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
