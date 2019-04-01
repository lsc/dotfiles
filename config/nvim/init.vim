call plug#begin('~/.config/nvim/plugged')
	Plug 'Shougo/Deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/neco-syntax'
	Plug 'airblade/vim-gitgutter'
	Plug 'arcticicestudio/nord-vim'
	Plug 'deoplete-plugins/deoplete-go', { 'do': 'make' }
	Plug 'ekalinin/Dockerfile.vim'
	Plug 'elzr/vim-json', { 'for': 'json' }
	Plug 'fatih/vim-go', { 'tag': 'v1.19' }
	Plug 'gcmt/taboo.vim'
	Plug 'godlygeek/tabular'
	Plug 'hashivim/vim-consul'
	Plug 'hashivim/vim-nomadproject'
	Plug 'hashivim/vim-packer'
	Plug 'hashivim/vim-terraform'
	Plug 'hashivim/vim-vagrant'
	Plug 'hashivim/vim-vaultproject'
	Plug 'juliosueiras/vim-terraform-completion'
	Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
	Plug 'junegunn/fzf.vim'
	Plug 'lervag/vimtex'
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'luochen1990/rainbow'
	Plug 'majutsushi/tagbar'
	Plug 'martinda/Jenkinsfile-vim-syntax'
	Plug 'mileszs/ack.vim'
	Plug 'neomake/neomake'
	Plug 'plasticboy/vim-markdown'
	Plug 'scrooloose/nerdtree'
	Plug 'stamblerre/gocode', {'rtp': 'vim/', 'do': '~/.vim/plugged/gocode/vim/symlink.sh'}
	Plug 'tarekbecker/vim-yaml-formatter'
	Plug 'thaerkh/vim-indentguides'
	Plug 'thaerkh/vim-workspace'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-ruby/vim-ruby'
	Plug 'ujihisa/neco-look'
	Plug 'troydm/zoomwintab.vim'
call plug#end()

:colorscheme nord
set backupcopy=auto
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

set termguicolors

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
let g:vimtex_compiler_progname = 'nvr'

" When I change dir in nerdtree, vim should follow.
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1
let g:NERDTreeWinSize=45

let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1
let g:terraform_completion_keys = 1
let g:terraform_registry_module_completion = 1

" Terraform deoplete configuration
call deoplete#custom#option('omni_patterns', {
\ 'complete_method': 'omnifunc',
\ 'terraform': '[^ *\t"{=$]\w*',
\})
call deoplete#initialize()

" NeoMake should run on each write and once every second
call neomake#configure#automake('w', 1000)

if executable('ag')
	let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git .terraform -g ""'
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
:autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
:autocmd BufNewFile,BufRead *.nomad     set filetype=terraform
:autocmd BufNewFile,BufRead *.hcl		set filetype=terraform

" Settings on a per filetype basis
:autocmd FileType sh,python,json,terraform,puppet,ruby,haml,sass,yaml,groovy setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Map CTRL-[jkhl] to move between splits
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Use space to toggle folds if we are on a fold
:nnoremap <space> za

" Sessions
:nnoremap <leader>s :ToggleWorkspace<CR>

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
:map <silent> <F3> :NERDTreeToggle<cr>
:map <silent> <C-n> :NERDTreeToggle<cr>
" Toggle taglist window
:nmap <silent> <F4> :TagbarToggle<cr>
:nmap <silent> <C-t> :TagbarToggle<cr>
" Clear hilightning
nnoremap <leader> <space> :noh <cr>
" FZF :rocket_ship:
nnoremap <C-P> :Files<CR>
nnoremap f :Files<cr>
nnoremap ; :Buffers<cr>
nnoremap T :Tags<cr>
nnoremap t :BTags<cr>
nnoremap s :Ag<cr>

function! OnTabEnter(path)
	if isdirectory(a:path)
		let dirname = a:path
	else
		let dirname = fnamemodify(a:path, ":h")
	endif
	execute "tcd ". dirname
endfunction()

autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))
