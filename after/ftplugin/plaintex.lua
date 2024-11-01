vim.bo.filetype = "latex"
vim.bo.commentstring = "% %s"

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.textwidth = 80

local fmtopts = "clrqj" -- tcqj
vim.bo.formatoptions = fmtopts
local function toggle_fmtopts()
  vim.bo.formatoptions = vim.bo.formatoptions == fmtopts and fmtopts .. "ta" or fmtopts
  vim.notify(string.format("Updated formatoptions: %s", vim.bo.formatoptions))
end

local u = require("utils") ---@type Utils

u.config.set_ft_keymap("n", "<leader>mL", u.writing.lorem, "Generate lorem ipsum text")
u.config.set_ft_keymap("n", "<leader>ta", toggle_fmtopts, "Toggle autoformat")
