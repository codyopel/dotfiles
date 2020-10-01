" Disable vi compatibility
set nocompatible

" Load plugins (.vim/pack/*/start/*/*)
packloadall

call plug#begin('~/.vim/plugged')
" Themes
Plug 'https://github.com/chlorm/vim-monokai-truecolor'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'

" Plugins
Plug 'https://github.com/ntpeters/vim-better-whitespace'
Plug 'https://github.com/google/vim-codefmt'
Plug 'https://github.com/sgur/vim-editorconfig'
Plug 'https://github.com/google/vim-maktaba'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/preservim/nerdcommenter'
Plug 'https://github.com/mhinz/vim-signify'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/godlygeek/tabular'
Plug 'https://github.com/benmills/vimux'
Plug 'https://github.com/mg979/vim-visual-multi'

" Languages
Plug 'https://github.com/chlorm/vim-syntax-elvish', { 'for': 'elvish' }
Plug 'https://github.com/fatih/vim-go', { 'for': 'go' }
Plug 'https://github.com/google/vim-jsonnet', { 'for': 'jsonnet' }
Plug 'https://github.com/LnL7/vim-nix', { 'for': 'nix' }
Plug 'https://github.com/vim-python/python-syntax', { 'for': 'python' }
Plug 'https://github.com/rust-lang/rust.vim', { 'for': 'rust' }
call plug#end()

" Enable syntax highlighting
if &t_Co > 7 || has("gui_running")
  syntax on
  set hlsearch
  colorscheme monokai
endif

" Plugin settings
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime=1
let g:airline_theme='murmur'

set
  \ ai
  "\ set background=none " Don't set to use terminals background
  "\ Allow backspacing over everything in insert mode
  \ backspace=indent,eol,start
  "\ Line length ruler
  \ colorcolumn=81
  "\ Highligh current line
  \ cursorline
  \ encoding=utf8
  \ expandtab
  \ ffs=unix,dos,mac
  "\ Keep 50 lines of command line history
  \ history=50
  \ incsearch
  \ laststatus=2
  \ list
  \ listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:•
  \ nobackup
  \ nomodeline
  \ noswapfile
  \ nowb
  "\ Line numbers
  \ number
  "\ Show the cursor position all the time
  \ ruler
  \ scrolloff=3
  \ shiftwidth=2
  \ si
  \ showbreak=↪
  "\ Display incomplete commands
  \ showcmd
  \ smarttab
  \ softtabstop=0
  \ tabstop=2
  "\ Set terminal title
  \ title
  "\ Restore previous title when exiting Vim
  \ titleold=
  \ wildmenu
  \ wildmode=list:longest

" Enable mouse support
if has('mouse')
  set mouse=a
endif

" Automatically strip whitespace
"autocmd BufWritePre * :call TrimWhitespace()

""""""""""""""""""""""""""""""""" Key binds """"""""""""""""""""""""""""""""""""
nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

highlight WhiteSpaces gui=undercurl guifg=White
match WhiteSpaces / \+/

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  "autocmd BufLeave * let b:winview = winsaveview()
  "autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  augroup END

  " Special Settings For Specific Files
  autocmd BufNewFile,BufRead *.nix
    \ set shiftwidth=2 |
    \ set tabstop=2
  autocmd Syntax go
    \ set shiftwidth=4 |
    \ set softtabstop=4 |
    \ set tabstop=4
  autocmd Syntax python
    \ set shiftwidth=4 |
    \ set softtabstop=4 |
    \ set tabstop=4
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif


if isdirectory($XDG_RUNTIME_DIR)
  let &viminfo = &viminfo . ",n" . $XDG_RUNTIME_DIR . "/viminfo"
else
  let &viminfo = ""
endif

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
augroup END
