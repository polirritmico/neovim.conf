vim.bo.filetype = "latex"
vim.bo.commentstring = "% %s"

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.textwidth = 80

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "a" - "o"

local u = require("utils")

u.config.set_ft_keymap("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
