--- Mappings

local u = require("utils") --[[@as Utils]]
local map = u.config.set_keymap
local toggle = u.config.toggle_vim_opt

-- Leader key
vim.g.mapleader = " "

-------------------------------------------------------------------------------
--- Workarounds for the spanish keyboard layout

-- Intercambiar {}[] ñ: Ñ;
vim.opt.langmap = "{[,}],[{,]},ñ:,Ñ\\;"

-- Fix `i{`/`i[` operations inverted by the above langmap
for _, cmd in pairs({ "c", "d", "v", "y" }) do
  map("n", cmd .. "i{", cmd .. "i[")
  map("n", cmd .. "i[", cmd .. "i{")
  map("n", cmd .. "a{", cmd .. "a[")
  map("n", cmd .. "a[", cmd .. "a{")
end

-- Fix goto (no reconoce la tecla `)
map({ "n", "v" }, "<bar>", "`", "`^` goto mark", true)

-- Fix <S-6> de `&` a `^`
map({ "n", "v" }, "&", "^")

-- Registros a +
map({ "n", "v" }, "+", '"')

-- Agregar signo de diálogo
map({ "i", "c" }, "ſ", "—") -- <A-w>
map({ "i", "c" }, "ð", "—") -- <A-d>

-------------------------------------------------------------------------------
--- Navigation and windows

-- Buffers navigation:
map("n", "<leader>l", "<Cmd>bnext<CR>", "Go to next buffer")
map("n", "<leader>h", "<Cmd>bprevious<CR>", "Go to previous buffer")

-- Center content after scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center view when searching
map("n", "n", "nzzzv", "Scroll window Upwards in the buffer and center the screen")
map("n", "N", "Nzzzv", "Scroll window Downwards in the buffer and center the screen")

-- Quick-list navigation
map("n", "<C-n>", "<Cmd>cnext<CR>zz", "Next quick-list element")
map("n", "<C-p>", "<Cmd>cprev<CR>zz", "Prev quick-list element")

-- Return to the position of the last insert
map("n", "<C-S-I>", "`^", "Go to the last cursor position in Insert mode")

-- Resize window using <ctrl> arrow keys
u.config.set_win_resize_keys()

-------------------------------------------------------------------------------
--- Adjust defaults behaviour

-- Close all buffers with/without saving and exit
map("n", "ZZ", "<Cmd>wa<CR>|<Cmd>qa<CR>", "Quit and save all buffers")
map("n", "ZQ", "<Cmd>qa!<CR>", "Quit without saving")

-- Flip full buffer info
map("n", "1<C-g>", "<C-g>")
map("n", "<C-g>", "1<C-g>")

-- Preserve selection after indent
map("v", "<", "<gv", "outer indent")
map("v", ">", ">gv", "inner indent")

--- Registers and clipboard
-- Flip paste mappings in visual-mode to avoid buffer replacement
map("v", "p", "P", "Paste without changing the `0` register")
map("v", "P", "p", "Paste replacing the `0` register")

-- Select pasted text
map({ "n", "v" }, "gp", "`[v`]", "Select pasted text")

-- Registers and system clipboard
map({ "n", "v" }, "<leader>y", '"+y', "Copy to system clipboard")
map({ "n", "v" }, "<leader>p", '<ESC>o<ESC>"+p', 'Paste from the `"` register to new line below')
map({ "n", "v" }, "<leader>P", '<ESC>o<ESC>"+P', 'Paste from the `"` register to new line above')

-- Open current fold and its inner folds by default
map("", "zo", "zczO")
map("", "zO", "zo")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
  cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
  cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
  cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
  cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Change to normal mode in terminal mode
map("t", "<Esc><Esc>", [[<c-\><c-n>]], "Change to normal mode (in terminal mode)")

-------------------------------------------------------------------------------
--- Toggle options:

map("n", "<leader>tc", function() toggle("foldcolumn", { a = "auto:3", b = "0" }) end, "Show/Hide fold column")
map("n", "<leader>tw", function() toggle("wrap", { global = true }) end, "On/Off line wrap")
map("n", "<leader>tl", function() toggle("relativenumber", { global = true }) end, "Absolute/Relative line numbers")

--- Toggle special windows:
map("n", "<leader>tq", u.custom.toggle_quickfix, "Show/Hide quickfix list")
map("n", "<leader>ts", u.custom.toggle_term, "Open/Close a shell terminal at the bottom")

-------------------------------------------------------------------------------

-- Set buffer path as root
map("n", "<leader>cd", u.helpers.buffer_path_to_cwd, "Set buffer path to cwd")

-- Open Dolphin at buffer path
map("n", "<leader>CD", u.custom.open_at_buffpath, "Open desktop file browser at buffer path")

-- Give execution permissions to the current buffer if matches a valid filetype
local valid_filetypes = { "bash", "sh", "python" }
map("n", "<leader>gx", function() u.helpers.chmod_exe(valid_filetypes) end, "Give execution permissions to the current buffer")

-- Setup runners per filetype (<leader>rr by default)
u.autocmd.set_runner("python", "!python %")
u.autocmd.set_runner("c", "!gcc % -o %:t:r -g; ./%:t:r")
u.autocmd.set_runner("bash", "!./%")
u.autocmd.set_runner("tex", "!xelatex -synctex=1 -interaction=batchmode -halt-on-error %")
u.autocmd.set_runner("lua", "PlenaryBustedFile %:p")

-- Setup custom spell commands
map({ "n", "v" }, "<leader>Si", "<Cmd>Spellen<CR>", "Enable english spell check")
map({ "n", "v" }, "<leader>Se", "<Cmd>Spelles<CR>", "Enable spanish spell check")
map({ "n", "v" }, "<leader>SS", "<Cmd>Spellend<CR>", "Disable spell check")

-- Shortcuts to configuration files (some of this maps are overwritten by Telescope)
map("n", "<leader>ci", "<Cmd>e " .. NeovimPath .. "/init.lua<CR>", "Config: Open `init.lua` (configuration entry point).")
map("n", "<leader>cm", "<Cmd>e " .. MyConfigPath .. "mappings.lua<CR>", "Config: Open the keys mappings settings")
map("n", "<leader>cg", "<Cmd>e " .. MyConfigPath .. "settings.lua<CR>", "Config: Open the general Neovim settings")
map("n", "<leader>cf", "<Cmd>e " .. NeovimPath .. "/after/ftplugin<CR>", "Config: Open filetypes settings")
map("n", "<leader>cU", "<Cmd>e " .. NeovimPath .. "/lua/utils/init.lua<CR>", "Config: Open the `utils/init.lua` file")
map("n", "<leader>cs", "<Cmd>e " .. MyConfigPath .. "snippets<CR>", "Config: Open the snippets folder")
