local u = require("utils")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.bo.textwidth = 0

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o"

u.config.set_ft_keymap("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
