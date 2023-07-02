--------------
-- Wrappers --
--------------

local exec = vim.api.nvim_exec
local g = vim.g
local set = vim.keymap.set

local function map(mode, key, command)
	vim.keymap.set(mode, key, command, {silent = true})
end

--------------
-- Mappings --
--------------

-- Teclas líder
g.mapleader = " "
g.maplocalleader = ","

-- Comandos a ñ (misma posición ANSI)
set({"n", "v"}, "ñ", ":")
set({"n", "v"}, "Ñ", ";")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
map("n", "<bar>", "`")

-- Mover líneas seleccionadas
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")

-- Mantener posición del cursor con J
--map("n", "J", "mzJ`z")

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

-- Registros y clipboard del sistema
map({"n", "v"}, "<leader>y", "\"+y")        -- Copia al clipboard del sistema
map("x", "<leader>p", "\"_dP")              -- Pegar sin borrar el registro
--map({"n", "v"}, "<leader>p", "o<ESC>\"+p")  -- Pegar de " en nueva línea
map({"n", "v"}, "<leader>P", "o<ESC>\"+p")  -- Pegar de " en nueva línea
map("x", "<leader>p", "\"_dP") -- Pegar sin rescribir el registro

-- Navegador de archivos 
set("n", "<leader>fe", vim.cmd.Ex) -- Reemplazado por nvim-tree

-- Evitar entrar Ex mode
map("n", "Q", "")

-- Atajos a configuraciones
map("n", "<leader>CM", ":e" .. MyConfigPath .. "remap.lua<CR>")
map("n", "<leader>CP", ":e" .. MyConfigPath .. "plugins.lua<CR>")
map("n", "<leader>CS", ":e" .. MyConfigPath .. "settings.lua<CR>")
map("n", "<leader>Cs", ":e" .. MyConfigPath .. "snippets<CR>")
map("n", "<leader>CG", ":e" .. MyConfigPath .. "globals.lua<CR>")
map("n", "<leader>CL", ":e" .. MyPluginConfigPath .. "lsp.lua<CR>")

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

-- Guardar y cargar sesión
exec("exec 'nnoremap <Leader>ss :mks! ' . "..
     "g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
exec("exec 'nnoremap <Leader>so :so ' . "..
     "g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)

-- Runners
local function autocmd(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"}, {pattern = filetype, command = cmd}
    )
end


-- Python run y tests
autocmd("python", [[noremap <leader>rr :! python __main__.py<CR>]])
autocmd("python", [[noremap <leader>rt :! python -m unittest discover . -b<CR>]])
autocmd("python", [[noremap <leader>rT :! python -m unittest discover .<CR>]])

