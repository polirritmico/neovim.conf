-- Fallback mappings

local function map(mode, key, command)
	vim.keymap.set(mode, key, command, {silent = true})
end

-- Teclas líder
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Comandos a ñ (misma posición ANSI)
vim.keymap.set({"n", "v"}, "ñ", ":")
vim.keymap.set({"n", "v"}, "Ñ", ";")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map("n", "<bar>", "`")

-- Atajos a configuraciones
local MyPluginConfigPath = " ~/.config/nvim/after/plugin/"
local MyConfigPath = " ~/.config/nvim/lua/polirritmico/"
map("n", "<leader>CG", ":e" .. MyConfigPath .. "globals.lua<CR>")
map("n", "<leader>CM", ":e" .. MyConfigPath .. "mappings.lua<CR>")
map("n", "<leader>CP", ":e" .. MyConfigPath .. "plugins.lua<CR>")
map("n", "<leader>CS", ":e" .. MyConfigPath .. "settings.lua<CR>")
map("n", "<leader>Cs", ":e" .. MyConfigPath .. "snippets<CR>")
map("n", "<leader>CL", ":e" .. MyPluginConfigPath .. "lsp.lua<CR>")

-- Mover líneas seleccionadas
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")

-- Preservar selección al indentar
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Moverse entre buffers:
map("n", "<leader>l", ":bnext<CR>")
map("n", "<leader>h", ":bprevious<CR>")
map("n", "<leader>db", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Regresar al archivo anterior "go back"
map("n", "<leader>gb", "<C-^>")

-- Centrar vista al hacer scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Centrar vista al hacer búsquedas
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Navegador de archivos. (Revisar nvim-tree)
--map("n", "<leader>fe", ":Lexplore<CR>")
map("n", "<leader>fe", vim.cmd.Ex)

-- Registros y clipboard del sistema
map({"n", "v"}, "<leader>y", "\"+y")        -- Copia al clipboard del sistema
map("x", "<leader>p", "\"_dP")              -- Pegar sin borrar el registro
map({"n", "v"}, "<leader>P", "o<ESC>\"+p")  -- Pegar de " en nueva línea
map("x", "<leader>p", "\"_dP") -- Pegar sin rescribir el registro

-- Evitar entrar Ex mode (no confundir con Ex de explorer)
map("n", "Q", "")

-- Cambiar dirección de las flechas en los wildmenu (prompt de nvim)
vim.cmd([[
    cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
    cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
    cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
    cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])
