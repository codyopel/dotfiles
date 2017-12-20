" Disable vi compatibility
set nocompatible

" Enable syntax highlighting
if &t_Co > 7 || has("gui_running")
  syntax on
  set hlsearch
  colorscheme monokai
endif

" Load plugins (.vim/pack/*/start/*/*)
packloadall

" Plugin settings
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime=1
let g:airline_theme='murmur'

filetype plugin indent on

set laststatus=2

" Indenation (tab)
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set number " Line numbers
set cursorline  " Highligh current line
set colorcolumn=81  " Line length ruler
"set background=none " Don't set to use terminals background
set list
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
" Can't find a clean way to highlight spaces or trail
"if has('patch-7.4.710')
"  set listchars+=space:.
"endif
set showbreak=↪\
"set listchars+=space:x
set nobackup
set nowb
set noswapfile
set smarttab
set ai
set si
set ffs=unix,dos,mac
set encoding=utf8
set wildmenu
set wildmode=list:longest
set title  " Set terminal title
set titleold=  " Restore previous title when exiting Vim
set scrolloff=3

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"  set nobackup   " do not keep a backup file, use versions instead
"else
"  set backup   " keep a backup file
"endif
set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time
set showcmd   " display incomplete commands
set incsearch   " do incremental searching

""""""""""""""""""""""""""""""""" Key binds """"""""""""""""""""""""""""""""""""
nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Enable mouse support
if has('mouse')
  set mouse=a
endif

hi WhiteSpaces gui=undercurl guifg=White
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

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " Special Settings For Specific Files
  autocmd BufNewFile,BufRead *.nix
    \ set shiftwidth=2 |
    \ set tabstop=2 |
    \ set expandtab
  autocmd Syntax {*sh,python,html,vim}
    \ set shiftwidth=2 |
    \ set tabstop=2 |
    \ set expandtab

  autocmd ColorScheme * highlight WhiteSpaces gui=undercurl guifg=White | match WhiteSpaces / \+/
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

set nomodeline

if isdirectory($HOME . "/.tmp/")
  let &viminfo = &viminfo . ",n" . $HOME . "/.tmp/viminfo"
else
  let &viminfo = ""
endif
