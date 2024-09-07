vim.opt.colorcolumn = { 81 } -- Guide columns position
vim.opt.textwidth = 80 -- Try to adjust lines to this max width size
vim.opt.conceallevel = 2 -- Hide syntax characters on lines (except the current)
vim.opt.cindent = false -- Avoid extra indentations with gq, gw
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

local utils = require("utils")

vim.keymap.set("", "gO", utils.custom.qf_toc_md, { desc = "Generate TOC" })
vim.api.nvim_create_user_command("TOC", utils.custom.generate_toc_md, {
  nargs = "?",
  desc = "Write TOC at current position. args: `depth_level` integer",
})
