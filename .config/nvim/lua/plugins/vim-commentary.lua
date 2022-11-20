-- vim-commentary:

-- Python
vim.api.nvim_create_autocmd(
    {"FileType"},
    {pattern = "python", command = "let b:commentary_format = '#%s'"}
)

-- Lua
vim.api.nvim_create_autocmd(
    {"FileType"},
    {pattern = "lua", command = "let b:commentary_format = '--%s'"}
)

-- C
vim.api.nvim_create_autocmd(
    {"FileType"},
    {pattern = "c", command = "let b:commentary_format = '/*%s*/'"}
)

--autocmd FileType * :let b:commentary_format = &commentstring

