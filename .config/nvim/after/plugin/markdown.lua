-- vim-markdown
local plugin_name = "vim-markdown"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Desactiva plegado de código
--vim.g.vim_markdown_folding_disabled = 1

-- Plegado de código inicial
vim.g.vim_markdown_folding_level = 6
vim.g.vim_markdown_folding_style_pythonic = 1
vim.cmd [[
    autocmd BufRead,BufNewFile *.markdown,*.md set conceallevel=2 foldlevelstart=6
]]

-- TOC
vim.g.vim_markdown_toc_autofit = 1

--vim.g.python_highlight_func_calls = 1
--vim.g.python_highlight_all = 1

--vim.g.vim_markdown_conceal = 2
--vim.g.vim_markdown_conceal_code_blocks = 0

-- Markdown previewer
--vim.g.mkdp_browser = "firefox-bin"
--vim.g.mkdp_filetypes = ["markdown"]

