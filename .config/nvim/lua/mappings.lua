--------------
-- WRAPPERS --
--------------

local exec = vim.api.nvim_exec
local set = vim.keymap.set
local g = vim.g

-- Funciones wrapper para simplificar la configuración
local function map(m, k, v)
	vim.keymap.set(m, k, v, {silent = true})
end

local function autocmd(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"},
        {pattern = filetype, command = cmd}
    )
end


--------------
-- MAPPINGS --
--------------

-- Teclas líder:
g.mapleader = " "
g.maplocalleader = ","

-- Comandos a ñ (misma posición ANSI)
set("n", "ñ", ":")
set("n", "Ñ", ";")

-- Goto mark no reconoce la tecla ` en teclado español
map("n", "<bar>", "`")

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

-- HELPERS --

-- Moverse entre buffers:
map("n", "<leader>l", ":bnext<CR>")
map("n", "<leader>h", ":bprevious<CR>")
map("n", "<leader>db", ":bdelete<CR>")
--map("n", "<leader>d", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Regresar al archivo anterior 'go back'
map("n", "<leader>gb", "<C-^>")



-- CLIPBOARD DEL SISTEMA --

-- '*' → selección, '+' → clipboard
map({"n", "v"}, "<leader>y", '"+y')        -- Copia al clipboard del sistema
map({"n", "v"}, "<leader>pp", 'o<ESC>"+p') -- Pegar del clipboard a nueva línea
map({"n", "v"}, "<leader>pP", 'O<ESC>"+p') -- Pegar del clipboard a línea ant.
map({"n", "v"}, "<leader>pi", '"+P')       -- pi, Pegar inline desde clipboard
map({"n", "v"}, "<leader>ps", '"*p')       -- Pegar desde la Selección (X11)



-- CONFIGURACIONES --

-- Carga las configuraciones del archivo actual
map("n", "<leader>CR", ":source %<CR>")

-- Abrir configuraciones
map("n", "<leader>CC", ":e $XDG_CONFIG_HOME/nvim/init.lua<CR>")
map("n", "<leader>CM", ":e $XDG_CONFIG_HOME/nvim/lua/mappings.lua<CR>")
map("n", "<leader>CP", ":e $XDG_CONFIG_HOME/nvim/lua/plugins.lua<CR>")
map("n", "<leader>CS", ":e $XDG_CONFIG_HOME/nvim/lua/settings.lua<CR>")



-- FUNCIONES

-- Guardar y cargar sesión
exec("exec 'nnoremap <Leader>ss :mks! ' . "..
     "g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
exec("exec 'nnoremap <Leader>so :so ' . "..
     "g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)

-- Runners
-- Python run __main__.py
autocmd("python", [[noremap <leader>rr :! python __main__.py<CR>]])

-- Unittest Python
-- "-b" → Silent output (lo muestra en caso de error)
autocmd("python", [[noremap <leader>rt :! python -m unittest discover . -b<CR>]])
autocmd("python", [[noremap <leader>rT :! python -m unittest discover .<CR>]])
-- Comenta o descomenta instrucciones para saltar o no todos los tests
autocmd("python", [[noremap <leader>ts :%s/ #@unittest.skip/ @unittest.skip/]])
autocmd("python", [[noremap <leader>tS :%s/ @unittest.skip/ #@unittest.skip/]])


