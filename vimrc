" vimrc for Lowe Schmidt
set nocompatible
set number
set backspace=indent,eol,start

" A TAB is a TAB and should be 4 spaces wide
" (I set expansion and width of tabs on a filetype level further down)
set shiftwidth=4
set tabstop=4
set softtabstop=4

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

set showmatch
set ignorecase
set smartcase
let mapleader=","

set encoding=utf-8

" Syntastic file checking, 
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

syntax on
filetype plugin on
filetype indent on

" Load abbreviations, maps and functions
:source ~/.vim/abbreviations.vim
:source ~/.vim/maps.vim
:source ~/.vim/functions.vim

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]\ %{fugitive#statusline()}\ %{SyntasticStatuslineFlag()}
set laststatus=2 
set tabline=%!ShortTabLine()

" Load templates based on extensions of file
:autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
" Set file types for a bunch of files to get syntax highlighting
:autocmd BufNewFile,BufRead *.nse set filetype=lua
:autocmd BufNewFile,BufRead *.ru  set filetype=ruby
:autocmd BufNewFile,BufRead *.thor set filetype=ruby
:autocmd BufNewFile,BufRead *.mk  set filetype=markdown
:autocmd BufNewFile,BufRead *.md  set filetype=markdown
:autocmd BufNewFile,BufRead *.textile set filetype=textile
:autocmd BufNewFile,BufRead *.pp  set filetype=puppet syntax=puppet

" Settings on a per filetype basis
:autocmd FileType lua,python setlocal tabstop=2 softtabstop=2 shiftwidth=2 
:autocmd FileType puppet,ruby,haml,sass setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Save file when losing focus
:autocmd FocusLost * :wa

" Call pathogen.
call pathogen#runtime_append_all_bundles() 
