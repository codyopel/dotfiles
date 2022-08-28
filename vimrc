" Disable vi compatibility
set nocompatible

" Load plugins (.vim/pack/*/start/*/*)
packloadall

" Windows does not provide HOME so you must set it.
let s:home = $HOME
if has('win32')
  let s:vimdir = s:home . '/viminfo'
else
  let s:vimdir = s:home . '/.vim'
endif

if empty(glob(s:vimdir.'/autoload/plug.vim'))
  silent execute '!curl -fsSLo ' . s:vimdir . '/autoload/plug.vim --create-dirs '.
      \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:vimdir . '/pack/vim-plug/opt/')
" Themes
Plug 'https://github.com/sainnhe/sonokai'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'

" Plugins
Plug 'https://github.com/sgur/vim-editorconfig'
Plug 'https://github.com/mhinz/vim-signify'

" Languages
Plug 'https://github.com/chlorm/vim-syntax-elvish', { 'for': 'elvish' }
Plug 'https://github.com/LnL7/vim-nix', { 'for': 'nix' }
call plug#end()

" Update on first launch after reboot
if !filereadable($XDG_RUNTIME_DIR . '/vim-plug.lock')
  PlugUpdate
  call writefile([""], $XDG_RUNTIME_DIR . '/vim-plug.lock', 'b')
endif

" Enable syntax highlighting
if &t_Co > 7 || has("gui_running")
  syntax on
  set hlsearch
  colorscheme sonokai
endif

" Plugin settings
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime=1
let g:airline_theme='murmur'

set
  \ autoindent
  "\ set background=none " Don't set to use terminals background
  "\ Allow backspacing over everything in insert mode
  \ backspace=indent,eol,start
  "\ Use system clipboard
  \ clipboard=unnamedplus
  "\ Line length ruler
  \ colorcolumn=81
  "\ Highligh current line
  \ cursorline
  \ encoding=utf8
  \ expandtab
  "\ command history
  \ history=50
  \ incsearch
  \ laststatus=2
  \ list
  \ listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:⋅
  \ nomodeline
  \ noswapfile
  \ nowritebackup
  "\ Line numbers
  \ number
  \ redrawtime=10000
  "\ Show the cursor position all the time
  \ ruler
  \ scrolloff=8
  \ shiftwidth=4
  \ smartindent
  \ showbreak=↪
  "\ Display incomplete commands
  \ showcmd
  \ smarttab
  \ tabstop=4
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

""""""""""""""""""""""""""""""""" Key binds """"""""""""""""""""""""""""""""""""
nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!


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

" Language/Files specific settings
autocmd FileType text setlocal textwidth=80
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
