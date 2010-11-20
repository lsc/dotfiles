set nocompatible
set number
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set softtabstop=4
set cursorline
set spell
set spelllang=en
set background=dark
set spellsuggest=5
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
set directory=~/.vim/tmp
set hidden
set wmh=0
set gdefault
set colorcolumn=90
set showmatch
set ignorecase
set smartcase
let mapleader=","

syntax on
filetype plugin on
filetype indent on

" Load abbreviations, maps and functions
:source ~/.vim/abbreviate.vim
:source ~/.vim/maps.vim
:source ~/.vim/func.vim
:source ~/.vim/support_functions.vim

" A More informative statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]
set laststatus=2 
set tabline=%!ShortTabLine()

" Load templates based on extensions of file
:autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl

:autocmd BufNewFile,BufRead *.nse set filetype=lua
:autocmd BufRead,BufNewFile *.ru set filetype=ruby
" Save file when losing focus
:autocmd FocusLost * :wa
call pathogen#runtime_append_all_bundles() 

