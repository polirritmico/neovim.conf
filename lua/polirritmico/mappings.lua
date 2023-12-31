--------------
-- MAPPINGS --
--------------

local map = require("polirritmico.utils").set_keymap

-- Leader key
vim.g.mapleader = " "

-- Comandos a ñ (misma posición ANSI)
map({"n", "v"}, "ñ", ":", "", true)
map({"n", "v"}, "Ñ", ";", "", true)

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map({"n", "v"}, "<bar>", "`", "", true)

-- Horizontal scroll
-- map({"n", "v"}, "zh", "z8h")
-- map({"n", "v"}, "zl", "z8l")

-- Preserve selection after indent
map("v", "<", "<gv", "", true)
map("v", ">", ">gv", "", true)

-- Toggle foldcolumn
_G.ToggleFoldColumn = function()
    vim.opt.foldcolumn = vim.api.nvim_win_get_option(0, "foldcolumn") == "0" and "auto:3" or "0"
end
map("n", "<leader>tf", ToggleFoldColumn, "Show/Hide fold column")

-- Line number toggle
map({"n", "v"}, "<leader>tN", "<CMD>set relativenumber!<CR>", "Toggle relative/absolute line numbers")

-- Buffers navigation:
map("n", "<leader>l", "<CMD>bnext<CR>", "Go to next buffer")
map("n", "<leader>h", "<CMD>bprevious<CR>", "Go to previous buffer")

-- Go back to previous file
map("n", "<leader>gb", "<C-^>", "Return to the previous buffer")

-- Return to the position of the last insert
map("n", "<C-i>", "`^", "Go to the last cursor position in Insert mode")

-- Center content after scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center view when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")

-- Quick-list and location-list
map("n", "<C-n>", "<cmd>cnext<CR>zz", "Next quick-list element")
map("n", "<C-p>", "<cmd>cprev<CR>zz", "Prev quick-list element")
-- map("n", "<leader>k", "<cmd>lnext<CR>zz", "Next location-list element")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz", "Prev location-list element")

-- Registers and system clipboard
map({"n", "v"}, "<leader>y", "\"+y", "Copy to system clipboard")
map("x", "<leader>p", "\"_dP", "Paste without changing the register copy register")
map({"n", "v"}, "<leader>P", "<ESC>o<ESC>\"+p", "Paste from \" register to new line")

-- Select pasted text
map({"n", "v"}, "gp", "`[v`]")

-- Avoid record macros by accident
map("n", "Q", "q")
map("n", "q", "<nop>")

-- Change to normal mode from terminal mode
map("t", "<c-n>", [[<c-\><c-n>]])

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
map("n", "<leader>gx", chmod_exe, "Give execution permissions to the current buffer")

-- Config shortcuts
map("n", "<leader>ci", "<CMD>e " .. MyConfigPath .. "init.lua<CR>", "Entry point for configurations")
map("n", "<leader>cm", "<CMD>e " .. MyConfigPath .. "mappings.lua<CR>", "Mappings/Keys settings")
map("n", "<leader>cP", "<CMD>e " .. MyPluginConfigPath .. "<CR>", "Plugins settings")
map("n", "<leader>cg", "<CMD>e " .. MyConfigPath .. "settings.lua<CR>", "General nvim settings")

map("n", "<leader>cs", "<CMD>e " .. MyConfigPath .. "snippets<CR>", "Snippets settings")
map("n", "<leader>cl", "<CMD>e " .. MyPluginConfigPath .. "core/lsp.lua<CR>", "LSP server configs")

map("n", "<leader>cp", "<cmd>Lazy<cr>", "Open Lazy")
map("n", "<leader>cM", "<cmd>Mason<cr>", "Open Mason")

-- Change directions of the arrow keys in the wildmenu to something with sense
vim.cmd([[
    cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
    cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
    cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
    cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Python runner
local autocmd = function(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"}, {pattern = filetype, command = cmd}
    )
end

autocmd("python", [[noremap <leader>rr :! python %<CR>]])
