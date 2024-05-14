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
u.custom.highlight_yanked_text()

--- Mouse related
-- Disable "How-to disable mouse" entry on mouse right click menu
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]])

-- vnoremenu PopUp.Copy "+y
vim.cmd([[vnoremenu PopUp.Copy "+y]])

--- Netrw
-- vim.g.netrw_keepdir = 0 -- Keep cwd sync with the browsing directory. Avoid move files error
-- vim.g.netrw_liststyle = 0 -- 0: one file per line, 1: 0 + timestamp, filezise, 2: multicol, 3: tree
-- vim.g.netrw_sizestyle = "H" -- Human-readable file sizes
-- vim.g.netrw_preview = 1 -- preview files in a vertical split
-- vim.g.netrw_localcopydircmd = "cp -r" -- defaults to recursive cp
-- vim.g.netrw_localmkdir = "mkdir -p" -- defaults to recursive dir creation
-- vim.g.netrw_localrmdir = "rm -r" -- to remove non-empty dirs
-- -- vim.g.netrw_list_hide = [[^\..*]] -- list of files/dirs to hide.
-- vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]] -- list of files/dirs to hide.
-- vim.g.netrw_hide = 1 -- 0: all, 1: not-hidden, 2: hidden-only

--- Code
opt.wrap = false -- Split long lines
opt.textwidth = 80 -- Adjust the lines to match this width limit

--- Indentation
opt.autoindent = true -- Indent based on the previous line
opt.cindent = true -- Indent comments at the beginning of the lines
opt.cinkeys = opt.cinkeys - "0#" -- Idem.
opt.expandtab = true -- Replace tab with spaces in Insert mode
opt.shiftround = true -- Approx. the indentation in multiples of shiftwidth
opt.shiftwidth = 4 -- Number of spaces used by indent and unindent
opt.smartindent = true -- Autoindent when adding a new line
opt.smarttab = true -- Tab follows tabstop, shiftwidth and softtabstop
opt.softtabstop = 4 -- Edit as if the tabs were 4 spaces
opt.tabstop = 4 -- Number of indentation spaces on the screen

--- Code folding
opt.foldmethod = "expr" -- Folding type (expr, indent, manual)
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Definition of the expression
opt.foldtext = "v:lua.require'utils.custom'.fold_text()" -- Wrap fold text function (in globals.lua)
opt.foldenable = false -- Disable folding when opening file
opt.foldlevelstart = 99 -- Don't fold all code when using folding
opt.foldlevel = 1 -- Fold only 1 level?
opt.foldminlines = 1 -- Minimum folding level
opt.foldnestmax = 3 -- Max nested folding level
opt.foldcolumn = "0" -- Default disabled. Change to auto:3 by toggle keymap function
opt.fillchars:append({ fold = " " }) -- Remove dots after foldtext

--- Misc

-- Disable health checks
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Replace grep with ripgrep
if vim.fn.executable("rg") == 1 then
  -- vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  -- vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Spellcheck commands
vim.api.nvim_create_user_command("Spelles", function() u.writing.dict_on("es") end, {})
vim.api.nvim_create_user_command("Spellen", function() u.writing.dict_on("en") end, {})
vim.api.nvim_create_user_command("Spellend", u.writing.dict_off, {})

-- TwoColumns mode
u.writing.set_two_columns_mode()

-- Read shebang to determine shell script filetype
u.autocmd.set_bash_ft_from_shebang()

-- Redirect the output of a command into a new buffer
u.helpers.set_cmd_redirection()

-- Create scratch buffers for taking notes
u.custom.set_create_scratch_buffers()
