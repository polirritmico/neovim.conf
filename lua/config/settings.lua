--- General Settings

local u = require("utils") ---@type Utils
local opt = vim.opt

--- Nvim language
vim.cmd("language en_US.utf8")

--- Generals
opt.errorbells = false -- Disable error notifications
opt.mouse = "a" -- Enables mouse support
opt.timeout = true -- Enables wait time for key combinations
opt.timeoutlen = 2000 -- 1000ms default

--- Searches
opt.ignorecase = true -- Ignore capitalization when searching
opt.smartcase = true -- Match capitalization only if there are capital letters
opt.incsearch = true -- Show results while searching
opt.inccommand = "split" -- Show the changes into a split window
opt.magic = true -- Standard regext patterns

-- Set terminal emulator options.
u.autocmd.setup_term({ number = false, relativenumber = false })

-- Saves the current cursor position in the file.
u.custom.save_cursor_position()

--- Appearance
opt.cmdheight = 1 -- 0 to remove the command line below the statusbar
opt.colorcolumn = { 80, 100 } -- Guide columns positions
opt.laststatus = 3 -- Global status bar (not one for each window)
opt.number = true -- Shows the current line number instead of 0
opt.relativenumber = true -- Show relative line numbers
opt.showmode = false -- Show status in command area
opt.title = true -- Set the window name
opt.scrolloff = Workstation and 6 or 3 -- To leave N lines before/after on scrolling

-- Highlight yanked text
u.autocmd.highlight_yanked_text()

--- Mouse related
-- Disable "How-to disable mouse" entry on mouse right click menu
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]])

-- vnoremenu PopUp.Copy "+y
vim.cmd([[vnoremenu PopUp.Copy "+y]])

--- Code
opt.wrap = false -- Split long lines
opt.textwidth = 80 -- Adjust the lines to match this width limit

--- Indentation
opt.autoindent = true -- Indent based on the previous line
opt.cindent = true -- Indent comments at the beginning of the lines
opt.cinkeys = opt.cinkeys - "0#" -- Idem.
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftround = true -- Round the indentation to a multiple of `shiftwidth`
opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
opt.smartindent = true -- Autoindent when adding a new line (for C-like languages)
opt.smarttab = true -- Tab follows `tabstop`, `shiftwidth` and `softtabstop`
opt.softtabstop = 4 -- Number of spaces added or removed by <Tab> or <BS>
opt.tabstop = 4 -- Number of indentation spaces on the screen

--- Code folding
opt.foldenable = false -- Disable folding when opening file
opt.foldlevelstart = 99 -- When opening a file, start with all folds open (up to level 99)
opt.foldlevel = 1 -- Fold only the top level (1) during the session
opt.foldminlines = 1 -- Minimum number of lines for a fold to be created
opt.foldnestmax = 3 -- Max number of nested folds
opt.foldcolumn = "0" -- Default disabled. Change to auto:3 by toggle keymap function

opt.foldmethod = "expr" -- Folding type (expr, indent, manual)
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Definition of the expression. To use Treesitter folding: "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.require'utils.custom'.fold_text()" -- Wrap fold text function (in globals.lua)
opt.fillchars = "fold: " -- Remove default dots after foldtext

--- Filetypes
vim.filetype.add({
  extension = {
    qml = "qmljs",
    tex = "tex", -- Force LaTeX over plaintex files
  },
  pattern = {
    [".*/playbooks/.+%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.+%.ya?ml"] = "yaml.ansible",
    [".*/.*ansible.*%.ya?ml"] = "yaml.ansible",
  },
})

--- Misc

-- Disable health checks
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Replace grep with ripgrep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --follow"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Spellcheck commands
vim.api.nvim_create_user_command("Spelles", function() u.writing.dict_on("es") end, {})
vim.api.nvim_create_user_command("Spellen", function() u.writing.dict_on("en") end, {})
vim.api.nvim_create_user_command("Spellend", u.writing.dict_off, {})

-- TwoColumns mode
u.writing.set_two_columns_mode()

-- Read shebang to determine shell script filetype
u.autocmd.set_bash_ft_from_shebang()

-- Set a custom command to redirect the output of a command into a buffer
u.helpers.set_cmd_redirection()

-- Resize windows splits when the neovim's terminal windows size has change
u.autocmd.autoresize_windows()
