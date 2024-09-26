local u = require("utils")
local map = u.config.set_keymap

vim.opt.colorcolumn = { 81 } -- Guide columns position
vim.opt.textwidth = 80 -- Try to adjust lines to this max width size
vim.opt.conceallevel = 2 -- Hide syntax characters on lines (except the current)
vim.opt.cindent = false -- Avoid extra indentations with gq, gw
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

map("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
map("", "gO", u.custom.qf_toc_md, "Generate TOC")

vim.api.nvim_create_user_command("TOC", u.custom.generate_toc_md, {
  nargs = "?",
  desc = "Write TOC at current position. args: `depth_level` integer",
})
