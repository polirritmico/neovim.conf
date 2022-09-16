-- UltiSnips
-- To split the window
--let g:UltiSnipsEditSplit="vertical"

-- UltiSnips stuff 
--let g:UltiSnipsSnippetDirectories = ['/$HOME/.config/nvim/UltiSnips', 'UltiSnips']
--let g:UltiSnipsExpandTrigger = "<nop>"
--inoremap <expr> <CR> pumvisible() ? \
--<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"

-- Trigger
vim.g.UltiSnipsExpandTrigger="<C-j>"
vim.g.UltiSnipsJumpForwardTrigger="<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<C-k>"

-- YCM compatibilidad con UltiSnips
--let g:ycm_use_ultisnips_completer = 1
--let g:ycm_key_list_stop_completion = ['<C-y>']

