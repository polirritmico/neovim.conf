local u = require("utils")
local map = u.config.set_keymap

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o" - "t"
vim.opt_local.commentstring = "<!-- %s -->"

map({ "n", "v" }, "<leader>gd", u.custom.vue_go_component_def, "Go to def workaround")
