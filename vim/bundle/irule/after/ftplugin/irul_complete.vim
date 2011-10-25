" ============================================================================
" irule_complete.vim auto completion for iRules. Based almost
" entirely from 'pydiction', by Ryan Kulla.
" For more information on pydiction, see:
" http://www.vim.org/scripts/script.php?script_id=850
"
" Contibuted by: Matt Cauthorn, f5 Networks, Inc.
" ============================================================================
"
" Version: 1.0, for Vim 7
" Last Modified: April 11, 2010
" Installation: On Linux, put this file in ~/.vim/after/ftplugin/
"               On Windows, put this file in C:\vim\vimfiles\ftplugin\
"                        (assuming you installed vim in C:\vim\).
"               You may install the other files anywhere. 
"               In .vimrc, add the following:
"                   filetype plugin on
"                   let g:irul_location = 'path/to/complete-dict'
"               Optionally, you set the completion menu height like:
"                   let g:irul_menu_height = 20
"               The default menu height is 15
"               To do case-sensitive searches, set noignorecase (:set noic).
" Usage: Type part of an iRule keyword, module name, etc.
"        then hit the TAB key and it will auto-complete (as long as it 
"        exists in the complete-dict file.
"        You can also use Shift-Tab to Tab backwards.
" ============================================================================

" added this on my own.
" 

if v:version < 700
    echoerr "irul requires vim version 7 or greater."
    finish
endif


" Make the Tab key do iRule code completion:
inoremap <silent> <buffer> <Tab> 
         \<C-R>=<SID>SetVals()<CR>
         \<C-R>=<SID>TabComplete('down')<CR>
         \<C-R>=<SID>RestoreVals()<CR>

" Make Shift+Tab do iRule code completion in the reverse direction:
inoremap <silent> <buffer> <S-Tab> 
         \<C-R>=<SID>SetVals()<CR>
         \<C-R>=<SID>TabComplete('up')<CR>
         \<C-R>=<SID>RestoreVals()<CR>


if !exists("*s:TabComplete")
    function! s:TabComplete(direction)
        " Check if the char before the char under the cursor is an 
        " underscore, letter, number, dot or opening parentheses.
        " If it is, and if the popup menu is not visible, use 
        " I_CTRL-X_CTRL-K ('dictionary' only completion)--otherwise, 
        " use I_CTRL-N to scroll downward through the popup menu or
        " use I_CTRL-P to scroll upward through the popup menu, 
        " depending on the value of a:direction.
        " If the char is some other character, insert a normal Tab:
        "if searchpos('[_a-zA-Z0-9.(]\%#', 'nb') != [0, 0] 
        "added by MC below to handle "::"
        if searchpos('[_a-zA-Z0-9.(:]\%#', 'nb') != [0, 0] 
            if !pumvisible()
                return "\<C-X>\<C-K>"
            else
                if a:direction == 'down'
                    return "\<C-N>"
                else
                    return "\<C-P>"
                endif
            endif
        else
            return "\<Tab>"
        endif
    endfunction
endif


if !exists("*s:SetVals") 
    function! s:SetVals()
        " Save and change any config values we need.

        " Temporarily change isk to treat periods and opening 
        " parenthesis as part of a keyword -- so we can complete
		"
        let s:irul_save_isk = &iskeyword
        "setlocal iskeyword +=.,(
        "Added ":" for iRules - MC
        setlocal iskeyword +=_,:,(

        " Save any current dictionaries the user has set:
        let s:irul_save_dictions = &dictionary
        " Temporarily use only irul's dictionary:
        let &dictionary = g:irul_location

        " Save the ins-completion options the user has set:
        let s:irul_save_cot = &completeopt
        " Have the completion menu show up for one or more matches:
        "let &completeopt = "menu,menuone"
		"MC: Changed to fix up the default menu opt behavior which is annoying.
        let &completeopt = "longest,menuone"

        " Set the popup menu height:
        let s:irul_save_pumheight = &pumheight
        if !exists('g:irul_menu_height')
            let g:irul_menu_height = 15
        endif
        let &pumheight = g:irul_menu_height

        return ''
    endfunction
endif

if !exists("*s:RestoreVals")
    function! s:RestoreVals()
        " Restore the user's initial values.
        let &dictionary = s:irul_save_dictions
        let &completeopt = s:irul_save_cot
        let &pumheight = s:irul_save_pumheight
        let &iskeyword = s:irul_save_isk

        return ''
    endfunction
endif

