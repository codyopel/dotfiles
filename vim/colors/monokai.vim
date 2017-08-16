" Copyright (c) 2015-2016, Cody Opel <codyopel@gmail.com>.
"
" Use of this source code is governed by the terms of the
" BSD-3 license.  A copy of the license can be found in
" the `LICENSE' file in the top level source directory.

"

hi clear

if version > 700
    " no guarantees for version 7.0 and below, but
    " this makes it stop complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

let g:colors_name="monokai"
let s:monokai_original = 1

"
" Support for 256-color terminal
"
hi Normal       ctermfg=15 ctermbg=none """
hi CursorLine               ctermbg=234 cterm=none
hi CursorLineNr ctermfg=9               cterm=none
hi Boolean      ctermfg=5
hi Character    ctermfg=3
hi Number       ctermfg=5
hi String       ctermfg=3
hi Conditional  ctermfg=1
hi Constant     ctermfg=5               cterm=bold
hi Cursor       ctermfg=16  ctermbg=253
hi Debug        ctermfg=225             cterm=bold
hi Define       ctermfg=14
hi Delimiter    ctermfg=241

hi DiffAdd                     ctermbg=24
hi DiffChange      ctermfg=114 ctermbg=239
hi DiffDelete      ctermfg=162 ctermbg=53
hi DiffText                    ctermbg=102 cterm=bold

hi Directory       ctermfg=10               cterm=bold
hi Error           ctermfg=219 ctermbg=89
hi ErrorMsg        ctermfg=199 ctermbg=16    cterm=bold
hi Exception       ctermfg=10               cterm=bold
hi Float           ctermfg=5
hi FoldColumn      ctermfg=67  ctermbg=16
hi Folded          ctermfg=67  ctermbg=16
hi Function        ctermfg=10
hi Identifier      ctermfg=10              cterm=none
hi Ignore          ctermfg=244 ctermbg=232
hi IncSearch       ctermfg=193 ctermbg=16

hi keyword         ctermfg=1
hi Label           ctermfg=229               cterm=none
hi Macro           ctermfg=193
hi SpecialKey      ctermfg=14

hi MatchParen      ctermfg=233  ctermbg=9 cterm=bold
hi ModeMsg         ctermfg=229
hi MoreMsg         ctermfg=229
hi Operator        ctermfg=3

" complete menu
hi Pmenu           ctermfg=14  ctermbg=16
hi PmenuSel        ctermfg=255 ctermbg=242
hi PmenuSbar                   ctermbg=232
hi PmenuThumb      ctermfg=14

hi PreCondit       ctermfg=10               cterm=bold
hi PreProc         ctermfg=9
hi Question        ctermfg=14
hi Repeat          ctermfg=15
hi Search          ctermfg=0   ctermbg=222   cterm=NONE

" marks column
hi SignColumn      ctermfg=10 ctermbg=235
hi SpecialChar     ctermfg=1
hi SpecialComment  ctermfg=245               cterm=bold
hi Special         ctermfg=14
if has("spell")
  hi SpellBad                ctermbg=52
  hi SpellCap                ctermbg=17
  hi SpellLocal              ctermbg=17
  hi SpellRare  ctermfg=none ctermbg=none  cterm=reverse
endif
hi Statement       ctermfg=1
hi StatusLine      term=reverse ctermfg=233 ctermbg=15
set laststatus=2
hi StatusLineNC    ctermfg=244 ctermbg=232
hi StorageClass    ctermfg=9
hi Structure       ctermfg=14
hi Tag             ctermfg=1
hi Title           ctermfg=166
hi Todo            ctermfg=231 ctermbg=232   cterm=bold

hi Typedef         ctermfg=14
hi Type            ctermfg=14                cterm=none
hi Underlined      ctermfg=244               cterm=underline

hi VertSplit       ctermfg=244 ctermbg=232   cterm=bold
hi VisualNOS                   ctermbg=238
hi Visual                      ctermbg=235
hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
hi WildMenu        ctermfg=14  ctermbg=16

hi Comment         ctermfg=8
hi CursorColumn                ctermbg=236
hi ColorColumn                 ctermbg=236
hi LineNr          ctermfg=8 ctermbg=233
hi NonText         ctermfg=8

hi SpecialKey      ctermfg=8

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
