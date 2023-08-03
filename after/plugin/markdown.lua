-- vim-markdown
if not Check_loaded_plugin("vim-markdown") then return end

-- Fix plegado de código inicial
vim.g.vim_markdown_folding_level = 6
vim.g.vim_markdown_folding_style_pythonic = 1
vim.cmd([[
    autocmd BufRead,BufNewFile *.markdown,*.md set conceallevel=2 foldlevelstart=6
]])

vim.g.vim_markdown_toc_autofit = 1  -- TOC
vim.g.vim_markdown_conceal_code_blocks = 0  -- Muestra bloques de código
