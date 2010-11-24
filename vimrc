" vimrc for lowe schmidt 
set nocompatible
set number
set backspace=indent,eol,start

" I prefer 4 spaces for a tab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set cursorline

set spell
set spelllang=en
set spellsuggest=5

set background=dark
set smartindent
set copyindent 
set completeopt=longest,menuone
set mouse=a
set ofu=syntaxcomplete#Complete

set foldenable
set foldmethod=syntax
set ruler

set wildmenu
set wildignore+=*.o,*.obj,.git,.svn,*.png,*.jpeg,*.jpg,*.gif,*.pyc,*.bak
set wildmode=list:longest

set clipboard+=unnamed
set iskeyword=_,$,#,@,%

" Directory for vim swap files
set directory=~/.vim/tmp

set hidden
set wmh=0
set gdefault

" Colorcolumn was first supported in version 7.3
if version >= 730 
	set colorcolumn=90
endif

set showmatch
set ignorecase
set smartcase
let mapleader=","

syntax on
filetype plugin on
filetype indent on

" Load abbreviations, maps and functions
:source ~/.vim/abbreviations.vim
:source ~/.vim/maps.vim
:source ~/.vim/functions.vim

" A More informative statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]\ %{fugitive#statusline()}
set laststatus=2 
set tabline=%!ShortTabLine()

" Load templates based on extensions of file
:autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
" Set some file types normally not recognized
:autocmd BufNewFile,BufRead *.nse set filetype=lua
:autocmd BufNewFile,BufRead *.ru  set filetype=ruby
:autocmd BufNewFile,BufRead *.mk  set filetype=mkd

" Settings on a per filetype basis
:autocmd FileType ruby   setlocal tabstop=2 softtabstop=2 shiftwidth=2 
:autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2 
:autocmd FileType c      setlocal tabstop=8 softtabstop=8 shiftwidth=8

" Save file when losing focus
:autocmd FocusLost * :wa

" Call pathogen.
call pathogen#runtime_append_all_bundles() 

