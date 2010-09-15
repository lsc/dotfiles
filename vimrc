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
set colorcolumn=80
set showmatch

syntax on
filetype plugin on
filetype indent on
" Load abbreviations, maps and functions
:source ~/.vim/abbreviate.vim
:source ~/.vim/maps.vim
:source ~/.vim/func.vim
let mapleader=","
" Command-t related 
let g:CommandTCancelMap='<C-x>'
" Mojolicious
let mojo_disable_html = 1
autocmd FileType perl syn include @perlData syntax/MojoliciousTemplate.vim
" A More informative statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]
set laststatus=2 
set tabline=%!ShortTabLine()

" Load templates based on extensions of file
:autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
" Add lua syntax highlighting to Nmap script files (.nse extension)
:autocmd BufNewFile,BufRead *.nse set filetype=lua
:autocmd BufRead,BufNewFile *.c set softtabstop=8
