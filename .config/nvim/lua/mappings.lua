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
set({"n", "v"}, "ñ", ":")
set({"n", "v"}, "Ñ", ";")

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
--map("n", "<leader>db", ":bdelete<CR>")
map("n", "<leader>db", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Regresar al archivo anterior 'go back'
map("n", "<leader>gb", "<C-^>")

-- Centrar vista al hacer scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")


-- REGISTROS Y CLIPBOARD DEL SISTEMA --
-- Toda la info en :help registers
--map({"n", "v"}, "p", '"0p')
--map({"n", "v"}, "P", '"0P')
map({"n", "v"}, "<leader><leader>p", '"0p')
map({"n", "v"}, "<leader><leader>P", '"0P')

-- y/Y: Solo yank guarda en el registro <0>
-- y/Y/d/D/x/X/c/C/s/S: modifican el registro <">
-- <*>: registro de selección, <+>: registro de clipboard
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
map("n", "<leader>CP", ":e $XDG_CONFIG_HOME/nvim/lua/plugins/init.lua<CR>")
map("n", "<leader>CS", ":e $XDG_CONFIG_HOME/nvim/lua/settings.lua<CR>")
map("n", "<leader>CU", ":e $XDG_CONFIG_HOME/nvim/snips/<CR>")



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

-- Lua nvim
autocmd("lua", [[noremap <leader>rr :source %<CR>]])



-------------
-- Plugins --
-------------

-- Telescope / Exploración de archivos
map({"n", "v"}, "<leader>fe", "<CMD>Ex<CR>")                    -- file explorer
map({"n", "v"}, "<leader>ff", "<CMD>Telescope find_files<CR>")  -- find files
map({"n", "v"}, "<leader>fg", "<CMD>Telescope live_grep<CR>")   -- find grep
map({"n", "v"}, "<leader>fb", "<CMD>Telescope buffers<CR>")     -- find buffers
map({"n", "v"}, "<leader>fr", "<CMD>Telescope oldfiles<CR>")    -- find recents
map({"n", "v"}, "<leader>fh", "<CMD>Telescope help_tags<CR>")   -- find help
map({"n", "v"}, "<leader>fs",                                   -- find selected
    "<CMD>lua require'telescope.builtin'.grep_string{}<CR>")
map({"n", "v"}, "<leader>fF",                                   -- ff from current buffer location
    "<CMD>lua require'telescope.builtin'.find_files{cwd = vim.fn.expand('%:p:h')}<CR>")


-- DAP Debugger
map({"n", "v"}, "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
map({"n", "v"}, "<F3>", "<Cmd>lua require'dap'.step_over()<CR>")
map({"n", "v"}, "<F2>", "<Cmd>lua require'dap'.step_into()<CR>")
map({"n", "v"}, "<F12>", "<Cmd>lua require'dap'.step_out()<CR>")
map({"n", "v"}, "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
map({"n", "v"}, "<Leader>do", "<Cmd>lua require'dap'.repl.open()<CR>")
map({"n", "v"}, "<Leader>dr", "<Cmd>lua require'dap'.run_last()<CR>")
map({"n", "v"}, "<Leader>dg", "<Cmd>lua require'dapui'.toggle()<CR>")
map({"n", "v"}, "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(" ..
                             "vim.fn.input('Breakpoint condition: '))<CR>")
map({"n", "v"}, "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, " ..
                              "nil, vim.fn.input('Log point message: '))<CR>")


