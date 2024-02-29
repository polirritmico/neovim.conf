vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o"

-- Fix gf
vim.opt_local.suffixesadd:prepend(".lua")
vim.opt_local.suffixesadd:prepend("init.lua")
-- vim.opt_local.path:prepend(vim.fn.stdpath("config") .. "/lua")
