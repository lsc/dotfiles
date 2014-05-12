" vimrc for Lowe Schmidt
set nocompatible
set relativenumber
set number
set backspace=indent,eol,start

set rtp+=~/.vim/bundle/vundle

call vundle#rc()

" Lets vundle these bundles!
Bundle 'gmarik/vundle'
" 
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/syntastic.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'rodjek/vim-puppet'
Bundle 'godlygeek/tabular'
" Snipmate and its dependecies
Bundle 'garbas/vim-snipmate'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
"
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'jnwhiteh/vim-golang'
Bundle 'vimwiki/vimwiki'
Bundle 'airblade/vim-gitgutter'
Bundle 'Valloric/YouCompleteMe'
Bundle 'altercation/vim-colors-solarized'

:colorscheme solarized


" A TAB is a TAB and should be 4 spaces wide
" (I set expansion and width of tabs on a filetype level further down)
set shiftwidth=4
set tabstop=4
set softtabstop=4

set background=dark
set copyindent 
set completeopt=longest,menuone
set mouse=a

set foldenable
set foldmethod=syntax
set ruler

set wildmenu
set wildignore+=*.o,*.obj,.git,.svn,*.png,*.jpeg,*.jpg,*.gif,*.pyc,*.bak
set wildmode=list:longest

set clipboard+=unnamed
set iskeyword=_,$,#,@,%

" Directory for vim swap files
set directory=/tmp

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

" When I change dir in nerdtree, vim should follow.
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1

syntax on
filetype plugin on
filetype indent on

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]\ %{fugitive#statusline()}\ %{SyntasticStatuslineFlag()}
set laststatus=2 

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

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

let g:ycm_key_list_select_completion = [ '<ENTER>' ]

" Map CTRL-[jkhl] to move between splits
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Toggle menu and toolbar with CTRL+F2
:map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
\set guioptions-=T <Bar>
\set guioptions-=m <Bar>
\else <Bar>
\set guioptions+=T <Bar>
\set guioptions+=m <Bar>
\endif <CR>

" Use space to toggle folds if we are on a fold
:nnoremap <space> za
" Headline macros
:map h1 yypVr=o
:map h2 yypVr-o
:map h3 :s/\(.+\)/-\1-/<cr>o
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
nnoremap <leader><space> :noh<cr>
" Create new vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>l
" Save file when losing focus
:autocmd FocusLost * :wa
