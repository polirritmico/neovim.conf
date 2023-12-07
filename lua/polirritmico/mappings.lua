--------------
-- Wrappers --
--------------

local g = vim.g
local set = vim.keymap.set

--------------
-- Mappings --
--------------

-- Leader keys
g.mapleader = " "
-- g.maplocalleader = ","

-- Comandos a ñ (misma posición ANSI)
set({"n", "v"}, "Ñ", ";")
set({"n", "v"}, "ñ", ":")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
set({"n", "v"}, "<bar>", "`")

-- Horizontal scroll
Keymap({"n", "v"}, "zh", "z8h")
Keymap({"n", "v"}, "zl", "z8l")

-- Preserve selection after indent
Keymap("v", "<", "<gv")
Keymap("v", ">", ">gv")

-- Toggle foldcolumn
_G.ToggleFoldColumn = function()
    vim.opt.foldcolumn = vim.api.nvim_win_get_option(0, "foldcolumn") == "0" and "auto:3" or "0"
end
Keymap("n", "<leader>tf", ToggleFoldColumn, "Show/hide fold column")

-- Line number toggle
Keymap({"n", "v"}, "<leader>tN", "<CMD>set relativenumber!<CR>", "Toggle relative/absolute line numbers")

-- Buffers navigation:
Keymap("n", "<leader>l", "<CMD>bnext<CR>", "Go to next buffer")
Keymap("n", "<leader>h", "<CMD>bprevious<CR>", "Go to previous buffer")
Keymap("n", "<leader>db", "<CMD>bp<bar>sp<bar>bn<bar>bd<CR>", "Delete (close) current buffer")
Keymap("n", "<leader>dB", "<CMD>bd<CR>", "Delete current buffer and close its window")

-- Go back to previous file
Keymap("n", "<leader>gb", "<C-^>", "Return to the previous buffer")

-- Return to the position of the last insert
Keymap("n", "<C-i>", "`^", "Go to the last cursor position in Insert mode")

-- Center content after scrolling
Keymap("n", "<C-d>", "<C-d>zz")
Keymap("n", "<C-u>", "<C-u>zz")

-- Center view when searching
Keymap("n", "n", "nzzzv")
Keymap("n", "N", "Nzzzv")

-- Quick-list and location-list
Keymap("n", "<C-n>", "<cmd>cnext<CR>zz", "Next quick-list element")
Keymap("n", "<C-p>", "<cmd>cprev<CR>zz", "Prev quick-list element")
-- Keymap("n", "<leader>k", "<cmd>lnext<CR>zz", "Next location-list element")
-- Keymap("n", "<leader>j", "<cmd>lprev<CR>zz", "Prev location-list element")

-- Registers and system clipboard
Keymap({"n", "v"}, "<leader>y", "\"+y", "Copy to system clipboard")
Keymap("x", "<leader>p", "\"_dP", "Paste without changing the register copy register")
Keymap({"n", "v"}, "<leader>P", "<ESC>o<ESC>\"+p", "Paste from \" register to new line")

-- Select pasted text
Keymap({"n", "v"}, "gp", "`[v`]")

-- Avoid Ex entering Ex mode (not to be confused with Explorer)
Keymap("n", "Q", "")

-- Change to normal mode from terminal mode
Keymap("t", "<c-n>", [[<c-\><c-n>]])

-- Give execution permissions to the current buffer if its filetype is in the list
local valid_filetypes = { "bash", "sh", "python" }
local chmod_exe = function()
    for _, ft in pairs(valid_filetypes) do
        if ft == vim.bo.filetype then
            vim.cmd([[!chmod +x %]])
            return
        end
    end
    print("The current buffer does not have a valid filetype: " .. vim.inspect(valid_filetypes))
end
Keymap("n", "<leader>gx", chmod_exe, "Give execution permissions to the current buffer")

-- Config shortcuts
Keymap("n", "<leader>CG", ":e" .. MyConfigPath .. "globals.lua<CR>", "Global variables and functions settings")
Keymap("n", "<leader>CM", ":e" .. MyConfigPath .. "mappings.lua<CR>", "Mappings/Keys settings")
Keymap("n", "<leader>CP", ":e" .. MyConfigPath .. "plugins.lua<CR>", "Plugins settings")
Keymap("n", "<leader>CS", ":e" .. MyConfigPath .. "settings.lua<CR>", "General nvim settings")
Keymap("n", "<leader>Cs", ":e" .. MyConfigPath .. "snippets<CR>", "Snippets settings")
Keymap("n", "<leader>CL", ":e" .. MyPluginConfigPath .. "lsp.lua<CR>", "LSP server configs")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
    cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
    cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
    cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
    cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Save and load sessions
-- if vim.g.sessions_dir ~= nil then
--     exec("exec 'nnoremap <Leader>ss :mks! ' . "..
--         "g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
--     exec("exec 'nnoremap <Leader>so :so ' . "..
--         "g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
-- end

-- Python runner
local autocmd = function(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"}, {pattern = filetype, command = cmd}
    )
end

autocmd("python", [[noremap <leader>rr :! python __main__.py<CR>]])

