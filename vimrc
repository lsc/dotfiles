set nocompatible
set number
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set softtabstop=4
no expandtab
set cursorline
set spell
set spelllang=en
set background=dark
set spellsuggest=5
set smartindent
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

syntax on
filetype plugin on
" Load abbreviations, maps and functions
:source ~/.vim/abbreviate.vim
:source ~/.vim/maps.vim
:source ~/.vim/func.vim

" C-tags related variables
let g:ctags_statusline=0
let g:generate_tags=1
let g:ctags_title=1
let generate_tags=1
" Command-t related 
let g:CommandTCancelMap='<C-x>'
" A More informative statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]
set laststatus=2 
set tabline=%!ShortTabLine()

" Load templates based on extensions of file
:autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
" Save and restore sessions automaticly
":autocmd VimEnter * call LoadSession()
":autocmd VimLeave * call SaveSession()
"silent source! Session.vim
