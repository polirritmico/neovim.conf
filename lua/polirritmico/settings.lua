local opt = vim.opt
local g = vim.g

-------------------
-- FUNCTIONALITY --
-------------------

--- Language
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
opt.magic = true -- Standard regext patterns
-- opt.inc = "" -- Avoid real time changes to substitutions -- set inc=

-- Enter into insert mode when opening :terminal
vim.cmd([[autocmd TermOpen term://* startinsert]])

-- Saves the current cursor position in the file.
vim.cmd([[
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 0 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])

--- Wildmenu
-- opt.wildmenu = true         -- Advanced command completion
-- opt.wildmode = "full"       -- :help wildmode

----------------
-- APPEARANCE --
----------------

opt.cmdheight = 1 -- 0 to remove the command line below the statusbar
opt.colorcolumn = { 80, 100 } -- Guide columns positions
opt.cursorline = false -- Underline the cursor line
opt.laststatus = 3 -- Global status bar (not one for each window)
opt.number = true -- Shows the current line number instead of 0
opt.relativenumber = true -- Show relative line numbers
opt.showmode = false -- Show status in command area
opt.title = true -- Set the window name
opt.scrolloff = Workstation and 6 or 3 -- To leave N lines before/after on scrolling

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

--- Mouse related
-- Disable "How-to disable mouse" entry on mouse right click menu
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]])

-- vnoremenu PopUp.Copy "+y
vim.cmd([[vnoremenu PopUp.Copy "+y]])

--- Netrw
g.netrw_keepdir = 0 -- Keep cwd sync with the browsing directory. Avoid move files error
g.netrw_liststyle = 0 -- 0: one file per line, 1: 0 + timestamp, filezise, 2: multicol, 3: tree
g.netrw_sizestyle = "H" -- Human-readable file sizes
g.netrw_preview = 1 -- preview files in a vertical split
g.netrw_localcopydircmd = "cp -r" -- defaults to recursive cp
g.netrw_localmkdir = "mkdir -p" -- defaults to recursive dir creation
g.netrw_localrmdir = "rm -r" -- to remove non-empty dirs
-- g.netrw_list_hide = [[^\..*]] -- list of files/dirs to hide.
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]] -- list of files/dirs to hide.
g.netrw_hide = 1 -- 0: all, 1: not-hidden, 2: hidden-only

----------
-- CODE --
----------

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
opt.foldenable = false -- Disable folding when opening file
opt.foldlevelstart = 99 -- Don't fold all code when using folding
opt.foldlevel = 1 -- Fold only 1 level?
opt.foldminlines = 1 -- Minimum folding level
opt.foldnestmax = 3 -- Max nested folding level
opt.foldcolumn = "0" -- Default disabled. Change to auto:3 by toggle keymap function
opt.foldtext = "v:lua.CustomFoldText()" -- Wrap fold text function (in globals.lua)
opt.fillchars:append({ fold = " " }) -- Remove dots after foldtext

------------
-- CUSTOM --
------------

-- TODO: Move to util?
-- Command to work with the same buffer in 2 column-type windows like printed articles.
vim.cmd([[
  command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
    \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
]])
