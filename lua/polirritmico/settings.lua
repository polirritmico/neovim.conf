local opt = vim.opt

-------------------
-- FUNCTIONALITY --
-------------------

--- Language
vim.cmd("language en_US.utf8")

--- Generals
opt.errorbells = false      -- Disable error notifications
opt.mouse = "a"             -- Enables mouse support
opt.timeout = true          -- Enables wait time for key combinations
opt.timeoutlen = 2000       -- 1000ms default

--- Searches
opt.ignorecase = true       -- Ignore capitalization when searching
opt.smartcase = true        -- Match capitalization only if there are capital letters
opt.incsearch = true        -- Show results while searching
opt.magic = true            -- Standard regext patterns

-- Enter into insert mode when opening :terminal
vim.cmd([[autocmd TermOpen term://* startinsert]])

-- Saves the current cursor position in the file.
vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 0 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])

--- Wildmenu
opt.wildmenu = true         -- Advanced command completion
opt.wildmode = "full"       -- :help wildmode


----------------
-- APPEARANCE --
----------------

opt.cmdheight = 1           -- 0 to remove the command line below the statusbar
opt.colorcolumn = {80,100}  -- Guide columns positions
opt.cursorline = false      -- Underline the cursor line
opt.laststatus = 3          -- Global status bar (not one for each window)
opt.number = true           -- Shows the current line number instead of 0
opt.relativenumber = true   -- Show relative line numbers
opt.scrolloff = 6           -- To leave N lines before/after on scrolling
opt.showmode = false        -- Show status in command area
opt.title = true            -- Set the window name

-- Highlight yanked text
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])


--- Mouse related
-- Disable "How-to disable mouse" entry on mouse right click menu
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]])

-- vnoremenu PopUp.Copy "+y
vim.cmd([[vnoremenu PopUp.Copy "+y]])


----------
-- CODE --
----------

opt.wrap = false            -- Split long lines
opt.textwidth = 80          -- Adjust the lines to match this width limit

--- Indentation
opt.autoindent = true       -- Indent based on the previous line
opt.cindent = true          -- Indent comments at the beginning of the lines
opt.cinkeys = opt.cinkeys - "0#" -- Idem.
opt.expandtab = true        -- Replace tab with spaces in Insert mode
opt.shiftround = true       -- Approx. the indentation in multiples of shiftwidth
opt.shiftwidth = 4          -- Number of spaces used by indent and unindent
opt.smartindent = true      -- Autoindent when adding a new line
opt.smarttab = true         -- Tab follows tabstop, shiftwidth and softtabstop
opt.softtabstop = 4         -- Edit as if the tabs were 4 spaces
opt.tabstop = 4             -- Number of indentation spaces on the screen

--- Code folding
opt.foldmethod = "expr"     -- Folding type (expr, indent, manual)
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Definition of the expression
opt.foldenable = false      -- Disable folding when opening file
opt.foldlevelstart = 99     -- Don't fold all code when using folding
opt.foldlevel = 1           -- Fold only 1 level?
opt.foldminlines = 1        -- Minimum folding level
opt.foldnestmax = 3         -- Max nested folding level
opt.foldcolumn = "0"        -- Default disabled. Change to auto:3 by toggle keymap function
opt.foldtext = "v:lua.CustomFoldText()" -- Wrap fold text function (in globals.lua)
opt.fillchars:append({fold = " "})      -- Remove dots after foldtext


------------
-- CUSTOM --
------------

-- TODO: Move to util?
-- Command to work with the same buffer in 2 column-type windows like printed articles.
vim.cmd([[
    command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
        \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
]])

