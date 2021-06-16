local u = require('utils')

vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g:go_highlight_functions = 1
vim.g:go_highlight_function_calls = 1
vim.g:go_highlight_operators = 1
vim.g:go_highlight_extra_types = 1
vim.g:go_highlight_build_constraints = 1
vim.g:go_highlight_generate_tags = 1

u.create_augroup({
        {'BufEnter', '*.go', 'nnmap <leader>t', '<Plug>(go-test)'}
        {'BufEnter', '*.go', 'nnmap <leader>tt', '<Plug>(go-test-func)'}
        {'BufEnter', '*.go', 'nnmap <leader>c', '<Plug>(go-coverage-toggle)'}
        {'BufEnter', '*.go', 'nnmap <leader>i', '<Plug>(go-info)'}
        {'BufEnter', '*.go', 'nnmap <leader>ii', '<Plug>(go-implements)'}
        {'BufEnter', '*.go', 'nnmap <leader>ci', '<Plug>(go-describe)'}
        {'BufEnter', '*.go', 'nnmap <leader>cc', '<Plug>(go-callers)'}
})
