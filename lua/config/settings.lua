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

--- Appearance
opt.cmdheight = 1 -- 0 to remove the command line below the statusbar
opt.colorcolumn = { 80, 100 } -- Guide columns positions
opt.laststatus = 3 -- Global status bar (not one for each window)
opt.number = true -- Shows the current line number instead of 0
opt.relativenumber = true -- Show relative line numbers
opt.showmode = false -- Show status in command area
opt.title = true -- Set the window name
opt.scrolloff = Workstation and 6 or 3 -- To leave N lines before/after on scrolling
opt.fillchars = {
  fold = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
}

-- Backups / Undo
opt.undofile = true -- Saves undo history into an undo file (`:h undodir`)

--- Code
opt.wrap = false -- Split long lines
opt.textwidth = 80 -- Adjust the lines to match this width limit

--- Code folding
opt.foldenable = false -- Disable folding when opening file
opt.foldlevelstart = 99 -- When opening a file, start with all folds open (up to level 99)
opt.foldlevel = 1 -- Fold only the top level (1) during the session
opt.foldminlines = 1 -- Minimum number of lines for a fold to be created
opt.foldnestmax = 3 -- Max number of nested folds
opt.foldcolumn = "0" -- Default disabled. Change to auto:3 by toggle keymap function

opt.foldmethod = "expr" -- Folding type (expr, indent, manual)
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Built-in
opt.foldtext = "v:lua.require'utils.custom'.fold_text()" -- Wrap fold text custom style

--- Code indent
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

--- Searches
opt.ignorecase = true -- Ignore capitalization when searching
opt.smartcase = true -- Match capitalization only if there are capital letters
opt.incsearch = true -- Show results while searching
opt.inccommand = "split" -- Show the changes into a split window
opt.magic = true -- Standard regex patterns

--- Mouse related
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]]) -- Remove menu entry
vim.cmd([[vnoremenu PopUp.Copy "+y]]) -- Copy to system clipboard

--- Custom
u.autocmd.autoresize_splits_at_window_resize()
u.autocmd.highlight_yanked_text({ timeout = 100 })
u.autocmd.save_cursor_position_in_file()
u.autocmd.set_bash_ft_from_shebang()
u.autocmd.setup_term_opts({ number = false, relativenumber = false, spell = false })

u.helpers.set_redirection_cmd()
u.writing.set_two_columns_mode()

-- Spellcheck commands
vim.api.nvim_create_user_command("Spelles", function() u.writing.dict_on("es") end, {})
vim.api.nvim_create_user_command("Spellen", function() u.writing.dict_on("en") end, {})
vim.api.nvim_create_user_command("Spellend", u.writing.dict_off, {})

--- Filetypes
vim.filetype.add({
  extension = { html = "html", qml = "qmljs", tex = "tex" },
  pattern = {
    [".*/playbooks/.+%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.+%.ya?ml"] = "yaml.ansible",
    [".*/.*ansible.*%.ya?ml"] = "yaml.ansible",
    [".*/.*[Dd][Jj][Aa][Nn][Gg][Oo].*%.html"] = "htmldjango",
  },
})

--- Misc

-- Disable health checks
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
