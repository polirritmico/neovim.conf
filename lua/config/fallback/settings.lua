--- Fallback Settings

local opt = vim.opt

-- General
opt.wrap = false -- Split long lines
opt.errorbells = false -- Disable error notifications
opt.mouse = "a" -- Enables mouse support
opt.timeout = true -- Enables wait time for key combinations
opt.timeoutlen = 2000 -- 1000ms default
opt.ignorecase = true -- Ignore capitalization when searching
opt.smartcase = true -- Match capitalization only if there are capital letters
opt.incsearch = true -- Show results while searching
opt.magic = true -- Standard regex patterns
opt.path:append("**") -- Subfolders searching with tab-completion

-- Indentation
opt.autoindent = true -- indent based on the previous line
opt.cindent = true -- indent comments at the beginning of the lines
opt.cinkeys = opt.cinkeys - "0#" -- idem.
opt.expandtab = true -- replace tab with spaces in insert mode
opt.shiftround = true -- approx. the indentation in multiples of shiftwidth
opt.shiftwidth = 4 -- number of spaces used by indent and unindent
opt.smartindent = true -- autoindent when adding a new line
opt.smarttab = true -- tab follows tabstop, shiftwidth and softtabstop
opt.softtabstop = 4 -- edit as if the tabs were 4 spaces
opt.tabstop = 4 -- number of indentation spaces on the screen

-- Windows
opt.equalalways = true -- Resize windows to the same size when closing one

-- Backups
opt.backup = false -- Do not use backup files. It bothers more than it helps
opt.undofile = false -- Disabled: Give errors if file is not saved on exit

--- Config UI

opt.colorcolumn = { 80, 100 } -- Guide margins for column width
opt.cursorline = false -- Underline the cursor line
opt.equalalways = true -- Resize windows to the same size when closing one
opt.hlsearch = false -- Disable highlight after searches
opt.number = true -- Shows the current line number instead of 0
opt.relativenumber = true -- Show relative line numbers
opt.scrolloff = 6 -- To leave N lines before/after on scrolling
opt.showmode = false -- Show status in command area
