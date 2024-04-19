--- Mappings

local u = require("utils") ---@type Utils
local map = u.config.set_keymap
local toggle = u.helpers.toggle_vim_opt

-- Leader key
vim.g.mapleader = " "

--- Workarounds for the spanish keyboard layout
-- Comandos a ñ (misma posición ANSI)
map({ "n", "v" }, "ñ", ":", "`:` ex cmd line", true)
map({ "n", "v" }, "Ñ", ";", "`;` repeat t/T/f/F", true)

-- registros a +
map({ "n", "v" }, "+", '"')

-- Fix goto (no reconoce la tecla `)
map({ "n", "v" }, "<bar>", "`", "`^` goto mark", true)

-- Preserve selection after indent
map("v", "<", "<gv", "outer indent")
map("v", ">", ">gv", "inner indent")

--- Toggles:
map("n", "<leader>tf", function() toggle("foldcolumn", "auto:3", "0") end, "Show/Hide fold column")
map("n", "<leader>tw", function() toggle("wrap") end, "On/Off line wrap")
map("n", "<leader>tl", function() toggle("relativenumber") end, "Absolute/Relative line numbers")
map("n", "<leader>tq", u.custom.toggle_quickfix, "Show/Hide quickfix list")

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

-- Flip paste mappings in visual-mode to avoid buffer replacement
map("v", "p", "P")
map("v", "P", "p")

-- Flip full buffer info
map("n", "1<C-g>", "<C-g>")
map("n", "<C-g>", "1<C-g>")

-- Registers and system clipboard
map({ "n", "v" }, "<leader>y", '"+y', "Copy to system clipboard")
map({ "n", "v" }, "<leader>p", '<ESC>o<ESC>"+p', 'Paste from the `"` register to new line below')
map({ "n", "v" }, "<leader>P", '<ESC>o<ESC>"+P', 'Paste from the `"` register to new line above')

-- Select pasted text
map({ "n", "v" }, "gp", "`[v`]", "Select pasted text")

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
u.autocmd.set_runner("python", runner_keymap, "!python %")
u.autocmd.set_runner("c", runner_keymap, "!gcc % -o %:t:r -g; ./%:t:r")
u.autocmd.set_runner("bash", runner_keymap, "!./%")
u.autocmd.set_runner("tex", runner_keymap, "!xelatex -synctex=1 -interaction=batchmode -halt-on-error %")

-- Setup custom spell commands
map({ "n", "v" }, "<leader>Se", "<Cmd>Spellen<CR>", "Enable english spell check")
map({ "n", "v" }, "<leader>Ss", "<Cmd>Spelles<CR>", "Enable spanish spell check")
map({ "n", "v" }, "<leader>SS", "<Cmd>Spellend<CR>", "Disable spell check")
