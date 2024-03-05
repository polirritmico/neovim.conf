--- Mappings

local u = require("utils") ---@type Utils
local map = u.config.set_keymap

-- Leader key
vim.g.mapleader = " "

-- Comandos a ñ (misma posición ANSI)
map({ "n", "v" }, "ñ", ":", "`:` ex cmd line", true)
map({ "n", "v" }, "Ñ", ";", "`;` repeat t/T/f/F", true)

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map({ "n", "v" }, "<bar>", "`", "`^` goto mark", true)

-- Preserve selection after indent
map("v", "<", "<gv", "outer indent", true)
map("v", ">", ">gv", "inner indent", true)

-- Toggle foldcolumn
map("n", "<leader>tf", u.custom.toggle_fold_column, "Show/Hide fold column")

-- Line number toggle
map({ "n", "v" }, "<leader>tl", "<Cmd>set relativenumber!<CR>", "Toggle relative/absolute line numbers")

-- Buffers navigation:
map("n", "<leader>l", "<Cmd>bnext<CR>", "Go to next buffer")
map("n", "<leader>h", "<Cmd>bprevious<CR>", "Go to previous buffer")

-- Return to the position of the last insert
map("n", "<C-i>", "`^", "Go to the last cursor position in Insert mode")

-- Center content after scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center view when searching
map("n", "n", "nzzzv", "Scroll window Upwards in the buffer and center the screen")
map("n", "N", "Nzzzv", "Scroll window Downwards in the buffer and center the screen")

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
map({ "n", "v" }, "<leader>P", '<ESC>o<ESC>"+p', 'Paste from the `"` register to new line')

-- Select pasted text
map({ "n", "v" }, "gp", "`[v`]", "Select pasted text")

-- Replace default <C-g> (:f) to custom function
map({ "n", "v" }, "<C-g>", u.helpers.buffer_info, "Get buffer fullpath info and current position in %")

-- Change to normal mode from terminal mode
map("t", "<C-n>", [[<c-\><c-n>]], "Change to normal mode (in terminal mode)")

-- Give execution permissions to the current buffer if matches a valid filetype
local valid_filetypes = { "bash", "sh", "python" }
map("n", "<leader>gx", function() u.helpers.chmod_exe(valid_filetypes) end, "Give execution permissions to the current buffer")

-- Config shortcuts
map("n", "<leader>ci", "<Cmd>e " .. NeovimPath .. "/init.lua<CR>", "Config: Open `init.lua` (configuration entry point).")
map("n", "<leader>cm", "<Cmd>e " .. MyConfigPath .. "mappings.lua<CR>", "Config: Open the keys mappings settings")
map("n", "<leader>cg", "<Cmd>e " .. MyConfigPath .. "settings.lua<CR>", "Config: Open the general Nvim settings")
map("n", "<leader>cs", "<Cmd>e " .. MyConfigPath .. "snippets<CR>", "Config: Open the snippets folder")
map("n", "<leader>cu", "<Cmd>e " .. NeovimPath .. "/lua/utils/init.lua<CR>", "Config: Open the `utils/init.lua` file")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
  cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
  cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
  cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
  cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Setup runners per filetype
local runner_keymap = "<leader>rr"
u.autocmds.set_autocmd_runner("python", runner_keymap, "!python %")
u.autocmds.set_autocmd_runner("c", runner_keymap, "!gcc % -o %:t:r -g; ./%:t:r")
u.autocmds.set_autocmd_runner("bash", runner_keymap, "!./%")

-- Setup custom spell commands
vim.keymap.set({ "n", "v" }, "<leader>Se", "<Cmd>Spellen<CR>", { silent = true, desc = "Enable english spell check" } )
vim.keymap.set({ "n", "v" }, "<leader>Ss", "<Cmd>Spelles<CR>", { silent = true, desc = "Enable spanish spell check" } )
vim.keymap.set({ "n", "v" }, "<leader>SS", "<Cmd>Spellend<CR>", { silent = true, desc = "Disable spell check" } )
