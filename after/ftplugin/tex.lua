vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.bo.textwidth = 0

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o"

vim.keymap.set("", "gO", require("utils").writing.loclist_toc_latex, { desc = "Generate TOC" })
