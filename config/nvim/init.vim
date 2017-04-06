call plug#begin('~/.config/nvim/plugged')
	Plug 'Shougo/deoplete.nvim'
	Plug 'altercation/vim-colors-solarized'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'derekwyatt/vim-scala'
	Plug 'ekalinin/Dockerfile.vim'
	Plug 'elzr/vim-json'
	Plug 'ervandew/supertab'
	Plug 'fatih/vim-go'
	Plug 'godlygeek/tabular'
	Plug 'hashivim/vim-consul'
	Plug 'hashivim/vim-packer'
	Plug 'hashivim/vim-terraform'
	Plug 'hashivim/vim-vagrant'
	Plug 'iCyMind/NeoSolarized'
	Plug 'majutsushi/tagbar'
	Plug 'mileszs/ack.vim'
	Plug 'neomake/neomake'
	Plug 'plasticboy/vim-markdown'
	Plug 'roidelapluie/vim-puppet'
	Plug 'scrooloose/nerdtree'
	Plug 'tpope/vim-fugitive'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-latex/vim-latex'
	Plug 'vim-ruby/vim-ruby'
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'zchee/deoplete-go'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'andrewstuart/vim-kubernetes'
call plug#end()

:colorscheme NeoSolarized

set list
set number

" A TAB is a TAB and should be 4 spaces wide
set shiftwidth=4
set tabstop=4
set softtabstop=4
set textwidth=139

set background=dark
set copyindent
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview
if has("gui_running")
	set termguicolors
endif

set foldenable
set foldmethod=syntax
set ruler

set wildignore+=.hg,.git,.svn                          " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.xbm   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest       " compiled object files
set wildignore+=*.spl                                  " compiled spelling word lists
set wildignore+=*.sw?                                  " Vim swap files
set wildignore+=*.DS_Store                             " OSX bullshit
set wildignore+=*.mo                                   " Django i18n
set wildignore+=*.pyc,*__pycache__*                    " Python byte code
set wildignore+=*.egg-info*,*.egg                      " Python package data
set wildignore+=*__init__.py                           " Python inits
set wildignore+=*.db                                   " SQLite3
set wildignore+=*logs/*,*dist/*                         " ...

if exists('+colorcolumn')
	set colorcolumn=+1
endif

set cursorline
set lazyredraw
set clipboard+=unnamed
set iskeyword=_,$,#,@,%
set autowrite
set shiftround
set linebreak
set synmaxcol=800

set scrolloff=3
set sidescroll=1
set sidescrolloff=2

set hidden
set wmh=0
set gdefault

set showmatch
set ignorecase
set smartcase
let mapleader=","

set listchars=tab:▸\ ,trail:¬,extends:❯,precedes:❮

" Enable keyword completion
let g:deoplete#enable_at_startup = 1
let g:airline_powerline_fonts = 1

" When I change dir in nerdtree, vim should follow.
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1
"
let g:terraform_align = 1

let g:ackprg = 'ag --nogroup --nocolor --column'

syntax on
filetype off
filetype plugin indent on

set laststatus=2

" Set file types for a bunch of files to get syntax highlighting
:autocmd BufNewFile,BufRead *.nse     set filetype=lua
:autocmd BufNewFile,BufRead *.ru      set filetype=ruby
:autocmd BufNewFile,BufRead *.thor    set filetype=ruby
:autocmd BufNewFile,BufRead *.mk      set filetype=make
:autocmd BufNewFile,BufRead *.md      set filetype=markdown
:autocmd BufNewFile,BufRead *.textile set filetype=textile
:autocmd BufNewFile,BufRead *.pp      set filetype=puppet syntax=puppet
:autocmd BufNewFile,BufRead *.sls     set filetype=yaml
:autocmd BufNewFile,BufRead *.gradle  set filetype=groovy
:autocmd BufNewFile,BufRead *.aurora  set filetype=python

" Settings on a per filetype basis
:autocmd FileType lua                               setlocal tabstop=2 softtabstop=2 shiftwidth=2
:autocmd FileType python                            setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
:autocmd FileType puppet,ruby,haml,sass,yaml,groovy setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
:autocmd FileType terraform                         setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd! BufWritePost * Neomake
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Map CTRL-[jkhl] to move between splits
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Use space to toggle folds if we are on a fold
:nnoremap <space> za

" Headline macros
:map h1 yypVr=o
:map h2 yypVr-o
:map h3 :s/\(.+\)/-\1-/<cr>o
"
" Format code
:nmap <F11> 1G=G
:imap <F11> <ESC>1G=G
" Paste indented code aka the "stairs"
:nnoremap <c-o> p=`]
" Toggle NerdTree window
:map <F3> :NERDTreeToggle<cr>
" Toggle taglist window
:nmap <silent> <F4> :TagbarToggle<cr>
" Clear hilightning
nnoremap <leader> <space> :noh <cr>

function! KillTrailingWhitespace()
	" Set the position. Default is that the cursor will be placed on any match.
	let pos = getpos('.')

	" Remove trailing whitespace from any row. Ingore all errors.
	silent! %s/\s\+$//e

" Remove trailing lines. Ignore all errors.
	silent! %s/\v\n+%$//e

	" Reset to the original position.
	call setpos('.',pos)
endfunction
