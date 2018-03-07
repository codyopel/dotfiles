" Copyright (c) 2015-2017, Cody Opel <codyopel@gmail.com>.
"
" Use of this source code is governed by the terms of the
" BSD-3 license.  A copy of the license can be found in
" the `LICENSE' file in the top level source directory.

" TODO:
" - Fix shell quotes being matched as `Operator`
" - Fix shell highlighting matching command arguments
" - Fix shell function brackets matching function highlighting
" - Fix shell if statement test brackets being matched as `Operator`
" - Fix vimscript if/else be matched as Statement instead of Conditional
" - Fix C function highlighting
" - Fix C operator highlighting
" - Fix C pointer highlighting ???
" - Fix C function call highlighting
" - Fix Python function argument highlighting

highlight clear
syntax reset
let g:colors_name="monokai"

syntax sync fromstart

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
let s:gui04 = "1a1919"
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

" https://github.com/vim/vim/blob/master/runtime/doc/syntax.txt
" See: highlight-groups
"call <sid>hi("name", "xxx", "xxx", "xxx", "xxx", "xxx", "xxx")

call <sid>hi("Normal", s:gui15, s:gui00, s:cterm15, "none", "", "")

call <sid>hi("Comment", s:gui07, "", s:cterm07, "", "", "")

call <sid>hi("Cursor", s:gui15, s:gui15, s:cterm15, s:cterm15, "bold", "")
"call <sid>hi("CursorIM", "", "", "", "", "", "")
call <sid>hi("CursorColumn", "", s:gui08, "", s:cterm08, "none", "")
call <sid>hi("CursorLine", "", s:gui08, "none", s:cterm08, "none", "")

call <sid>hi("ColorColumn", "", s:gui08, "", s:cterm08, "none", "")

call <sid>hi("LineNr", s:gui07, s:gui08, s:cterm07, s:cterm08, "none", "")
call <sid>hi("CursorLineNr", s:gui15, "", s:cterm03, "", "none", "")

call <sid>hi("Boolean", s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("Character", s:gui03, "", s:cterm03. "", "", "", "")
call <sid>hi("Number", s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("String", s:gui03, "", s:cterm03, "", "", "")

call <sid>hi("Builtin", s:gui06, "", s:cterm06, "", "", "")
call <sid>hi("Conditional", s:gui01, "", s:cterm01, "", "", "")
call <sid>hi("Constant", s:gui06, "", s:cterm06, "", "bold", "")
call <sid>hi("Debug", s:gui15, "", s:cterm15, "", "bold", "")
call <sid>hi("Define", s:gui14, "", s:cterm14, "", "", "")
call <sid>hi("Delimiter", s:gui08, "", s:cterm08, "", "", "")

call <sid>hi("EndOfBuffer", s:gui01, s:gui08, s:cterm01, s:cterm08, "", "")

call <sid>hi("DiffAdd", s:gui02, s:gui00, s:cterm02, s:cterm00, "", "")
call <sid>hi("DiffChange", s:gui03, s:gui00, s:cterm03, s:cterm00, "", "")
call <sid>hi("DiffDelete", s:gui01, s:gui00, s:cterm01, s:cterm00, "", "")
call <sid>hi("DiffText", s:gui15, s:gui00, s:cterm15, s:cterm00, "bold", "")

highlight Directory       ctermfg=10               cterm=bold
highlight Error           ctermfg=08 ctermbg=06
call <sid>hi("ErrorMsg", s:gui00, s:gui09, s:cterm00, s:cterm09, "", "")
highlight Exception       ctermfg=10               cterm=bold
highlight Float           ctermfg=05
highlight FoldColumn      ctermfg=05  ctermbg=00
highlight Folded          ctermfg=05  ctermbg=00
highlight Function        ctermfg=02
highlight Identifier      ctermfg=15              cterm=none
highlight Ignore          ctermfg=08 ctermbg=00
highlight IncSearch       ctermfg=03 ctermbg=00

highlight Typedef         ctermfg=06
highlight Type            ctermfg=06 cterm=none
highlight Structure       ctermfg=06
highlight StorageClass    ctermfg=06

" Pre processor
call <sid>hi("Include", s:gui01, "", s:cterm01, "", "", "")
call <sid>hi("Define", s:gui01, "", s:cterm01, "", "", "")
call <sid>hi("Macro", s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("PreCondit", s:gui10, "", s:cterm10, "", "bold", "")
call <sid>hi("PreProc", s:gui03, "", s:cterm03, "", "", "")

highlight Keyword         ctermfg=01
highlight Label           ctermfg=04               cterm=none

highlight MatchParen      ctermfg=09 ctermbg=none cterm=bold
highlight ModeMsg         ctermfg=03
highlight MoreMsg         ctermfg=04
highlight Operator        ctermfg=01

" complete menu
highlight Pmenu           ctermfg=14  ctermbg=00
highlight PmenuSel        ctermfg=15 ctermbg=08
highlight PmenuSbar                   ctermbg=00
highlight PmenuThumb      ctermfg=14

highlight Question        ctermfg=14
highlight Repeat          ctermfg=01
highlight Search          ctermfg=00   ctermbg=04   cterm=none

" marks column
highlight SignColumn      ctermfg=10 ctermbg=237
highlight SpecialChar     ctermfg=01
highlight SpecialComment  ctermfg=08               cterm=bold
highlight Special         ctermfg=14
if has("spell")
  highlight SpellBad                ctermbg=06
  highlight SpellCap                ctermbg=04
  highlight SpellLocal              ctermbg=04
  highlight SpellRare  ctermfg=none ctermbg=none  cterm=reverse
endif
highlight Statement       ctermfg=06
highlight StatusLine      term=reverse ctermfg=00 ctermbg=15
set laststatus=2
highlight StatusLineNC    ctermfg=08 ctermbg=00
highlight Tag             ctermfg=01
highlight Title           ctermfg=10
highlight Todo            ctermfg=06 ctermbg=none cterm=italic

highlight Underlined      ctermfg=08               cterm=underline

highlight VertSplit       ctermfg=08 ctermbg=00   cterm=bold
highlight VisualNOS                   ctermbg=09
highlight Visual                      ctermbg=237
highlight WarningMsg      ctermfg=15 ctermbg=09   cterm=bold
highlight WildMenu        ctermfg=14  ctermbg=00

" needs to be one shade lighter than bg color
highlight NonText ctermfg=237 guifg=gray
highlight SpecialKey ctermfg=237

""""""""""""""""""""""""""""""" Syntax Overrides """""""""""""""""""""""""""""""

hi def link diffAdded DiffAdd
hi def link diffChanged DiffChange
hi def link diffRemoved DiffDelete
hi def link diffNewFile DiffDelete
hi def link diffOldFile DiffText
hi def link diffFile DiffAdd

hi def link elvishException Keyword
hi def link elvishBuiltins Builtin

hi def link goConstants Boolean  " Arbitrarily use boolean for the correct color

" NOT for builtin python syntax
" See: https://github.com/vim-python/python-syntax
let g:python_highlight_all = 1
let g:python_print_as_function = 0
" syn keyword pythonFuncStatement def class nextgroup=pythonFunction skipwhite
" hi link pythonFuncStatement Statement
hi def link pythonStatement Keyword
hi def link pythonBuiltinFunc Statement
hi def link pythonRun Comment
hi def link pythonNone Boolean  " Arbitrarily use boolean for the correct color

hi def link shOperator Normal  " shOperator also includes !, &, and |
hi def link shExSingleQuote Normal
hi def link shQuote String

hi def link vimCommand Keyword

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
