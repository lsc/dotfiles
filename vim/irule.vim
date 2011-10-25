""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For the vim iRule Editor. Here is where all of the main settings
" are for the iRule portion. Edit this carefully! If you choose
" to add your own commands/code please post them back to 
" Dev Central!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
so $HOME/.vim/irule/pyfunc.vim
let $irulsyn='~/.vim/syntax/irul.vim' "Syntax file for *.irul files.
let g:irul_location='~/.vim/irule/irul_dict' "Location of the syntax dict.
au BufRead,BufNewFile *.irul set filetype=irul "If you name a file *.irul, set ftype.
au! Syntax irul source $irulsyn

" Custom commands as shortcuts
com -nargs=? Sav call PubRule(<f-args>)
com Ls  call GetRules()
com Get call OpenRule()
com -nargs=* Connect call Connect(<f-args>)
com New call NewRule()
com -nargs=? Apply call ApplyRule(<f-args>)
com -nargs=* Delete call DeleteRule(<f-args>)
com -nargs=1 Partition call Partition (<f-args>)


" MC - setup folds. Expand/collapse with space bar, and by
" defualt fold iRules code on event code blocks. We'll
" fold the GTM/LTM menus based on indent (see pyfunc.vim).
"nnoremap <space> za
nnoremap <space> zA
vnoremap <space> zf
set fmr={,}
set fdm=marker
" When creating a new rule, detect the file type (save the .irul
" extension)
filetype on

"custom fold text function for rules. Taken from: 
"http://tech.groups.yahoo.com/group/vim/message/56267
"by Gary Johnson.
function! MyFoldText()
        let n = v:foldend - v:foldstart + 1
        let i = indent(v:foldstart)
        let istr = ''
        while i > 0
                let istr = istr . ' '
                let i = i - 1
        endwhile
        return istr . "+-" . v:folddashes . " " . n . " Rules"
endfunction

