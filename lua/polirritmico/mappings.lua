--- Mappings

local utils = require(MyUser .. ".utils") ---@type Utils
local map = utils.set_keymap

-- Leader key
vim.g.mapleader = " "

-- Comandos a ñ (misma posición ANSI)
map({ "n", "v" }, "ñ", ":", "", true)
map({ "n", "v" }, "Ñ", ";", "", true)

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map({ "n", "v" }, "<bar>", "`", "", true)

-- Preserve selection after indent
map("v", "<", "<gv", "", true)
map("v", ">", ">gv", "", true)

-- Toggle foldcolumn
map("n", "<leader>tf", utils.toggle_fold_column, "Show/Hide fold column")

-- Line number toggle
map({ "n", "v" }, "<leader>rn", "<Cmd>set relativenumber!<CR>", "Toggle relative/absolute line numbers")

-- Buffers navigation:
map("n", "<leader>l", "<Cmd>bnext<CR>", "Go to next buffer")
map("n", "<leader>h", "<Cmd>bprevious<CR>", "Go to previous buffer")

-- Return to the position of the last insert
map("n", "<C-i>", "`^", "Go to the last cursor position in Insert mode")

-- Center content after scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center view when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<Cmd>resize +2<CR>", "Increase window height")
map("n", "<C-Down>", "<Cmd>resize -2<CR>", "Decrease window height")
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", "Increase window width")

-- Quick-list navigation
map("n", "<C-n>", "<Cmd>cnext<CR>zz", "Next quick-list element")
map("n", "<C-p>", "<Cmd>cprev<CR>zz", "Prev quick-list element")

-- Registers and system clipboard
map({ "n", "v" }, "<leader>y", '"+y', "Copy to system clipboard")
map("x", "<leader>p", '"_dP', "Paste without changing the register copy register")
map({ "n", "v" }, "<leader>P", '<ESC>o<ESC>"+p', 'Paste from " register to new line')

-- Select pasted text
map({ "n", "v" }, "gp", "`[v`]")

-- Change to normal mode from terminal mode
map("t", "<C-n>", [[<c-\><c-n>]])

-- Give execution permissions to the current buffer if matches a valid filetype
local valid_filetypes = { "bash", "sh", "python" }
map("n", "<leader>gx", function() utils.chmod_exe(valid_filetypes) end, "Give execution permissions to the current buffer")

-- Config shortcuts
map("n", "<leader>ci", "<Cmd>e " .. MyConfigPath .. "init.lua<CR>", "Entry point for configurations")
map("n", "<leader>cm", "<Cmd>e " .. MyConfigPath .. "mappings.lua<CR>", "Mappings/Keys settings")
map("n", "<leader>cP", "<Cmd>e " .. MyPluginConfigPath .. "<CR>", "Plugins settings")
map("n", "<leader>cg", "<Cmd>e " .. MyConfigPath .. "settings.lua<CR>", "General nvim settings")
map("n", "<leader>cs", "<Cmd>e " .. MyConfigPath .. "snippets<CR>", "Snippets settings")
map("n", "<leader>cL", "<Cmd>e " .. MyPluginConfigPath .. "core/lsp.lua<CR>", "LSP server configs")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
  cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
  cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
  cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
  cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Setup runners per filetype
local runner_keymap = "<leader>rr"
utils.set_autocmd_runner("python", runner_keymap, "!python %")
utils.set_autocmd_runner("c", runner_keymap, "!gcc % -o %:t:r -g; ./%:t:r")
utils.set_autocmd_runner("bash", runner_keymap, "!./%")
