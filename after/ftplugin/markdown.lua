local u = require("utils")
local map = u.config.set_ft_keymap

vim.opt.colorcolumn = { 81 } -- Guide columns position
vim.opt.textwidth = 80 -- Try to adjust lines to this max width size
vim.opt.conceallevel = 2 -- Hide syntax characters on lines (except the current)
vim.opt.cindent = false -- Avoid extra indentations with gq, gw
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

map("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
map("n", "gO", u.writing.loclist_toc_markdown, "TOC in the quickfix list")
