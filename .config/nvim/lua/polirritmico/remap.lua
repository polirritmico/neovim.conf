--------------
-- Wrappers --
--------------

local exec = vim.api.nvim_exec
local g = vim.g
local set = vim.keymap.set

local function map(mode, key, command)
	vim.keymap.set(mode, key, command, {silent = true})
end

local function autocmd(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"},
        {pattern = filetype, command = cmd}
    )
end


--------------
-- Mappings --
--------------

-- Teclas líder
g.mapleader = " "
g.maplocalleader = "."

-- Comandos a ñ (misma posición ANSI)
set({"n", "v"}, "ñ", ":")
set({"n", "v"}, "Ñ", ";")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map("n", "<bar>", "`")

-- Navegador de archivos
set("n", "<leader>fe", vim.cmd.Ex)

-- Cambiar dirección de las flechas en los wildmenu (prompt de nvim)
vim.cmd [[
    set wildcharm=<C-Z>
    cnoremap <expr> <up> getcmdline()[:1] is 'e ' && wildmenumode() ?
                \ "\<left>" : "\<up>"
    cnoremap <expr> <down> getcmdline()[:1] is 'e ' && wildmenumode() ?
                \ "\<right>" : "\<down>"
    cnoremap <expr> <left> getcmdline()[:1] is 'e ' && wildmenumode() ?
                \ "\<up>" : "\<left>"
    cnoremap <expr> <right> getcmdline()[:1] is 'e ' && wildmenumode() ?
                \ " \<bs>\<C-Z>" : "\<right>"
]]

-- Moverse entre buffers:
map("n", "<leader>l", ":bnext<CR>")
map("n", "<leader>h", ":bprevious<CR>")
map("n", "<leader>db", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Regresar al archivo anterior "go back"
map("n", "<leader>gb", "<C-^>")

-- Centrar vista al hacer scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Registros y clipboard del sistema
-- Info detallada en :help registers
map({"n", "v"}, "<leader>y", '"+y')        -- Copia al clipboard del sistema
map({"n", "v"}, "<leader>p", 'o<ESC>"+p')  -- Copia en nueva línea
map({"n", "v"}, "<leader>P", 'O<ESC>"+p')  -- Copia en nueva línea anterior


-- Atajos a configuraciones
local config_path = " $XDG_CONFIG_HOME/nvim/lua/polirritmico/"
map("n", "<leader>CM", ":e" .. config_path .. "remap.lua<CR>")
map("n", "<leader>CP", ":e" .. config_path .. "packer.lua<CR>")
map("n", "<leader>CS", ":e" .. config_path .. "settings.lua<CR>")
map("n", "<leader>CU", ":e" .. config_path .. "snips/<CR>")

-- Funciones
-- Guardar y cargar sesión
exec("exec 'nnoremap <Leader>ss :mks! ' . "..
     "g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
exec("exec 'nnoremap <Leader>so :so ' . "..
     "g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)

