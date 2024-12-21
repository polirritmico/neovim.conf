local u = require("utils")
local map = u.config.set_ft_keymap

vim.opt_local.colorcolumn = { 81 } -- Guide columns position
vim.opt_local.textwidth = 80 -- Try to adjust lines to this max width size
vim.opt_local.conceallevel = 2 -- Hide syntax characters on lines (except the current)
vim.opt_local.cindent = false -- Avoid extra indentations with gq, gw
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

map("n", "<leader>mg", u.writing.lorem, "Markdown: Generate lorem ipsum text")
map("n", "gl", u.writing.next_link, "Markdown: Move to the next link in the line")
