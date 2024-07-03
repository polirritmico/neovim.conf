--- Fallback mappings

local function map(mode, key, command)
  vim.keymap.set(mode, key, command, { silent = true })
end

-- Leader keys
vim.g.mapleader = " "

-- Comandos a ñ (misma posición ANSI)
vim.keymap.set({ "n", "v" }, "ñ", ":")
vim.keymap.set({ "n", "v" }, "Ñ", ";")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map("n", "<bar>", "`")

-- Preserve selection after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Buffers navigation:
map("n", "<leader>l", "<Cmd>bnext<CR>")
map("n", "<leader>h", "<Cmd>bprevious<CR>")
map("n", "<leader>db", "<Cmd>bp<bar>sp<bar>bn<bar>bd<CR>")
map("n", "<leader>dB", "<Cmd>bd<CR>")

-- Go back to previous file
map("n", "<leader>gb", "<C-^>")

-- Center content after scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center view when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- File navigation
map("n", "<leader>fe", vim.cmd.Ex)

-- Registers and system clipboard
map({ "n", "v" }, "<leader>y", '"+y')
map("x", "<leader>p", '"_dP')
map({ "n", "v" }, "<leader>P", '<ESC>o<ESC>"+p')

-- Avoid Ex entering Ex mode (not to be confused with Explorer)
map("n", "Q", "")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
  cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
  cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
  cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
  cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Config shortcuts
map("n", "<leader>ci", "<Cmd>e ~/.config/nvim/init.lua<CR>")
map("n", "<leader>cm", "<Cmd>e ~/.config/nvim/lua/config/mappings.lua<CR>")
map("n", "<leader>cg", "<Cmd>e ~/.config/nvim/lua/config/settings.lua<CR>")
map("n", "<leader>cl", "<Cmd>e ~/.config/nvim/lua/config/lazy.lua<CR>")
