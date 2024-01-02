vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- stylua: ignore
vim.opt_local.formatoptions = vim.opt_local.formatoptions
    + "r"
    - "o"
