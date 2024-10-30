vim.bo.filetype = "latex"
vim.bo.commentstring = "% %s"

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.textwidth = 80

local u = require("utils")

u.autocmd.set_formatoptions_in_dirs("latex", { add = "a", del = "o" }, { "content" })
u.config.set_ft_keymap("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
