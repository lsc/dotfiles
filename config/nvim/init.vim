function BuildComposer(info)
	if a:info.status != 'unchanged' || a.info.force
		if has('nvim')
			!cargo build --release
		else
			!cargo build --release --no-default-feature --features json-rpc
		endif
	endif
endfunction

call plug#begin('~/.config/nvim/plugged')
	Plug 'Shougo/Deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/neosnippet'
	Plug 'Shougo/neosnippet-snippets'
	Plug 'airblade/vim-gitgutter'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'ekalinin/Dockerfile.vim'
	Plug 'elzr/vim-json', { 'for': 'json' }
	Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer')}
	Plug 'fatih/vim-go', { 'tag': 'v1.17' }
	Plug 'godlygeek/tabular'
	Plug 'hashivim/vim-consul'
	Plug 'hashivim/vim-packer'
	Plug 'hashivim/vim-terraform'
	Plug 'hashivim/vim-vagrant'
	Plug 'juliosueiras/vim-terraform-completion'
	Plug 'lervag/vimtex'
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'luochen1990/rainbow'
	Plug 'majutsushi/tagbar'
	Plug 'martinda/Jenkinsfile-vim-syntax'
	Plug 'mattn/gist-vim'
	Plug 'mattn/webapi-vim'
	Plug 'mileszs/ack.vim'
	Plug 'morhetz/gruvbox'
	Plug 'mustache/vim-mustache-handlebars'
	Plug 'neomake/neomake'
	Plug 'plasticboy/vim-markdown'
	Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'tarekbecker/vim-yaml-formatter'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-latex/vim-latex'
"	Plug 'romainl/Apprentice'
"	Plug 'ervandew/supertab'
"	Plug 'w0rp/ale'
"	Plug 'andrewstuart/vim-kubernetes'
"	Plug 'christoomey/vim-tmux-navigator'
"	Plug 'derekwyatt/vim-scala'
"	Plug 'google/vim-jsonnet'
"	Plug 'roidelapluie/vim-puppet'
"	Plug 'vim-ruby/vim-ruby'
call plug#end()

:colorscheme gruvbox
" I want to resize splits with my mouse...
set mouse=a
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

let g:airline_powerline_fonts = 1

" When I change dir in nerdtree, vim should follow.
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1

let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1
let g:terraform_completion_keys = 1

" Terraform deoplete configuration
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
call deoplete#initialize()

" NeoMake should run on each write and once every second
call neomake#configure#automake('w', 1000)

" NeoSnippets configuration
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ neosnippet#expandable_or_jumpable() ?
	\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr> <TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


if executable('ag')
	let g:ackprg = 'ag --nogroup --nocolor --column'
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_use_caching = 0
endif

syntax on
filetype off
filetype plugin indent on

set laststatus=2

" Set file types for a bunch of files to get syntax highlighting
:autocmd BufNewFile,BufRead *.nse       set filetype=lua
:autocmd BufNewFile,BufRead *.ru        set filetype=ruby
:autocmd BufNewFile,BufRead *.thor      set filetype=ruby
:autocmd BufNewFile,BufRead *.mk        set filetype=make
:autocmd BufNewFile,BufRead *.md        set filetype=markdown
:autocmd BufNewFile,BufRead *.textile   set filetype=textile
:autocmd BufNewFile,BufRead *.pp        set filetype=puppet syntax=puppet
:autocmd BufNewFile,BufRead *.sls       set filetype=yaml
:autocmd BufNewFile,BufRead *.yml       set filetype=yaml
:autocmd BufNewFile,BufRead *.gradle    set filetype=groovy
:autocmd BufNewFile,BufRead *.aurora    set filetype=python
:autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
:autocmd BufNewFile,BufRead *.nomad		set filetype=terraform

" Settings on a per filetype basis
:autocmd FileType python,json,terraform,puppet,ruby,haml,sass,yaml,groovy setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Map CTRL-[jkhl] to move between splits
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Use space to toggle folds if we are on a fold
:nnoremap <space> za

" Use ESC to switch to normal mode in a Terminal
if has('nvim')
	tnoremap <Esc> <C-\><C-n>
	tnoremap <C-v><Esc> <Esc>
endif

" Headline macros
:map h1 yypVr=o
:map h2 yypVr-o
:map h3 :s/\(.+\)/-\1-/<cr>o
"
" Format code
:nmap <F11> 1G=G
:imap <F11> <ESC>1G=G
" Toggle NerdTree window
:map <F3> :NERDTreeToggle<cr>
" Toggle taglist window
:nmap <silent> <F4> :TagbarToggle<cr>
" Clear hilightning
nnoremap <leader> <space> :noh <cr>

:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
