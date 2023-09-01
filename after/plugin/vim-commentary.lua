-- Vim Commentary
if not Check_loaded_plugin("vim-commentary") then return end

-- Lua
vim.api.nvim_create_autocmd(
    { "FileType" },
    { pattern = "lua", command = "let b:commentary_format = '--%s'" }
)

-- C
vim.api.nvim_create_autocmd(
    { "FileType" },
    { pattern = "c", command = "let b:commentary_format = '/*%s*/'" }
)

--autocmd FileType * :let b:commentary_format = &commentstring
