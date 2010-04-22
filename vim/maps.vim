" Map some F keys to tags lookup
:nmap <buffer> <F7> <C-J>
:nmap <buffer> <S-F7> <C-T>
:nmap <buffer> <A-F7> :ptselect<cr>
:nmap <buffer> <F8> :tnext<cr>
:nmap <buffer> <C-F8> :tprev<cr>

" Map CTRL-[jkhl] to move between splits
:map <C-j> <C-W>j<C-W>_
:map <C-k> <C-W>k<C-W>_
:map <C-l> <C-W>l
:map <C-h> <C-W>h

" Toggle menu and toolbar with CTRL+F2
:map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
			\set guioptions-=T <Bar>
			\set guioptions-=m <Bar>
		    \else <Bar>
			\set guioptions+=T <Bar>
			\set guioptions+=m <Bar>
		    \endif <CR>

:nnoremap <space> za
" Headline macros
:map h1 yypVr=o
:map h2 yypVr-o
:map h3 :s/\(.+\)/-\1-/<cr>o
" Format code
:nmap <F11> 1G=G
:imap <F11> <ESC>1G=G
" Paste indented code aka the "stairs"
:nnoremap <c-p> p=`]
:map <F3> :NERDTreeToggle<cr>
