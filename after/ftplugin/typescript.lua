local u = require("utils")
local map = u.config.set_keymap

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o"

map(
  { "n", "v" },
  "<leader>gd",
  u.custom.vue_go_component_def,
  "Workaround to go to component def"
)
