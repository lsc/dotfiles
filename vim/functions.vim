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

" Create a bulleted list from the selected lines of text
function! BulletList()
    let lineno = line(".")
    call setline(lineno, "    * " . getline(lineno))
endfunction

function StartTerm()
  execute 'ConqueTerm ' . $SHELL . ' --login'
  setlocal listchars=tab:\ \ 
endfunction
