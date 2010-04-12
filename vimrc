set number
set nocompatible
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=8
set softtabstop=4
set cursorline
set spell
set spelllang=en
set background=dark
set spellsuggest=5
set smartindent
set completeopt=longest,menuone
set mouse=a
filetype plugin on
set ofu=syntaxcomplete#Complete

:inoremap <expr> <cr>  pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
:inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
:inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>
syntax on

:map <C-j> <C-W>j<C-W>_
:map <C-k> <C-W>k<C-W>_
:map <C-l> <C-W>l
:map <C-h> <C-W>h

:map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
			\set guioptions-=T <Bar>
			\set guioptions-=m <Bar>
		    \else <Bar>
			\set guioptions+=T <Bar>
			\set guioptions+=m <Bar>
		    \endif <CR>

" A More informative statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L][POS=\%04l.\%04v]
set laststatus=2 
" Set a different tab layout
" For terminal version

" Set tablines in consolemode
function ShortTabLine()
    let ret = ' '
    for i in range(tabpagenr('$'))
	" Select a the colourgroup for highligting active tab
	if i + 1 == tabpagenr()
	    let ret .= '%#errorMsg#'
	else
	    let ret .= '%#TabLine#'
        endif

	" Find the buffername for the tablabel
	let buflist = tabpagebuflist(i+1)
	let winnr = tabpagewinnr(i+1)
	let buffnername = bufname(buflist[winnr -1])
	let filename = fnamemodify(buffername, ':t')
	" Check if there is no name
	if filename == ' '
	    let filename = 'noname' 
        endif
	" Only show the six first letters of the name and 
	" .. if the filename is more then 8 letters 
	if strlen(filename) >= 8
	    let ret .= '['. filename[0:5].'..']'
        else 
	    let ret .= '['.filename.']'
	endif 
    endfor

    let ret .= '%#TabLineFill#%T'
    return ret
endfunction
set tabline=%!ShortTabLine()


function! CURR_CWD()
    let _dir = expand("%:p:h")
    exec "cd " . _dir
    unlet _dir
endfunction

autocmd BufEnter * call CURR_CWD()
