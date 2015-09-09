call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'benekastah/neomake' 
	Plug 'kien/ctrlp.vim'
	Plug 'scrooloose/nerdtree'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'godlygeek/tabular'
	Plug 'majutsushi/tagbar'
	Plug 'rodjek/vim-puppet'
	Plug 'fatih/vim-go'
	Plug 'elzr/vim-json'
	Plug 'sickill/vim-monokai'
	Plug 'plasticboy/vim-markdown'
	Plug 'w0ng/vim-hybrid'
	Plug 'jonathanfilip/vim-lucius'
	Plug 'tomasr/molokai'
	Plug 'jpo/vim-railscasts-theme'
call plug#end()

set number
:colorscheme hybrid

" A TAB is a TAB and should be 4 spaces wide
set shiftwidth=4
set tabstop=4
set softtabstop=4
set textwidth=139

set background=dark
set copyindent 
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

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
set wildignore+=bin,build,lib,share,man                " Python venv files
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

set encoding=utf-8
set listchars=tab:▸\ ,trail:¬,extends:❯,precedes:❮

" When I change dir in nerdtree, vim should follow.
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1

syntax on
filetype off
filetype plugin indent on

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]\ %{fugitive#statusline()} 
set laststatus=2 

" Set file types for a bunch of files to get syntax highlighting
:autocmd BufNewFile,BufRead *.nse set filetype=lua
:autocmd BufNewFile,BufRead *.ru  set filetype=ruby
:autocmd BufNewFile,BufRead *.thor set filetype=ruby
:autocmd BufNewFile,BufRead *.mk  set filetype=markdown
:autocmd BufNewFile,BufRead *.md  set filetype=markdown
:autocmd BufNewFile,BufRead *.textile set filetype=textile
:autocmd BufNewFile,BufRead *.pp  set filetype=puppet syntax=puppet
:autocmd BufNewFile,BufRead *.sls set filetype=yaml
:autocmd BufNewFile,BufRead *.gradle set filetype=groovy

" Settings on a per filetype basis
:autocmd FileType lua                               setlocal tabstop=2 softtabstop=2 shiftwidth=2
:autocmd FileType python                            setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
:autocmd FileType puppet,ruby,haml,sass,yaml,groovy setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

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
" Save file when losing focus
function! AutoSave()
  " We are not in git or the file is not modified. Do nothing.
  if exists('b:autosave') && b:autosave != 1 || &modified == 0
    return
  endif

  " We generally always want to run the BufWritePre. Only skip it if it is set
  " and set to zero.
  if !exists('b:autosave_bufwritepre') || b:autosave_bufwritepre != 0
    doau BufWritePre
  endif

  " Actually save the file! Will do nothing if the buffer has not file
  " allocated yet.
  silent! write

  " We don't always want to do the BufWritePost since it would clobber test
  " runners, linters or whatever. However, sometimes we actually do want it,
  " and for those times we specify this!
  if exists('b:autosave_bufwritepost') && b:autosave_bufwritepost == 1
    doau BufWritePost
  endif
endfunction

function! SetAutoSave()
  let b:autosave = finddir('.git', expand('%:p:h') . ';') != ""
endfunction

augroup autosave
  au!
  au InsertLeave,CursorHold,BufLeave * call AutoSave()
  au BufEnter,BufAdd * call SetAutoSave()
augroup END

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

augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   execute 'normal! g`"zvzz' |
    \ endif
augroup END
