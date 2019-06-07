function! myspacevim#before() abort
  nnoremap <C-j> <C-W>j<C-W>_
  nnoremap <C-k> <C-W>k<C-W>_
  nnoremap <C-l> <C-W>l
  nnoremap <C-h> <C-W>h
  let NERDTreeChDirMode=2
  let NERDTreeShowBookmarks=1
  let mapleader = ","

endfunction

function! myspacevim#after() abort
  let NERDTreeChDirMode=2
  let NERDTreeShowBookmarks=1
  let g:terraform_align = 1
  let g:terraform_fmt_on_save = 1
  let g:terraform_fold_sections = 1
  let g:terraform_completion_keys = 1
  let g:terraform_registry_module_completion = 1
  set listchars=tab:▸\ ,trail:¬,extends:❯,precedes:❮

  call deoplete#custom#option('omni_patterns', {
  \ 'complete_method': 'omnifunc',
  \ 'terraform': '[^ *\t"{=$]\w*',
  \})

  nnoremap <C-j> <C-W>j<C-W>_
  nnoremap <C-k> <C-W>k<C-W>_
  nnoremap <C-l> <C-W>l
  nnoremap <C-h> <C-W>h
endfunction
