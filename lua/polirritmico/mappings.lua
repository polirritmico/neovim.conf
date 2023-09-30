--------------
-- Wrappers --
--------------

local exec = vim.api.nvim_exec
local g = vim.g
local set = vim.keymap.set

--------------
-- Mappings --
--------------

-- Teclas líder
g.mapleader = " "
-- g.maplocalleader = ","

-- Comandos a ñ (misma posición ANSI)
set({"n", "v"}, "Ñ", ";")
set({"n", "v"}, "ñ", ":")

-- Fix goto mark (no reconoce la tecla ` en teclado español)
set({"n", "v"}, "<bar>", "`")

-- Mover líneas seleccionadas
Keymap("x", "J", ":m '>+1<CR>gv=gv", "Mover líneas seleccionadas hacia abajo")
Keymap("x", "K", ":m '<-2<CR>gv=gv", "Mover líneas seleccionadas hacia arriba")

-- Scroll horizontal
Keymap({"n", "v"}, "zh", "z8h")
Keymap({"n", "v"}, "zl", "z8l")

-- Preservar selección al indentar
Keymap("v", "<", "<gv")
Keymap("v", ">", ">gv")

-- Conmuta la columna de plegado (foldcolumn)
_G.ToggleFoldColumn = function()
    vim.opt.foldcolumn = vim.api.nvim_win_get_option(0, "foldcolumn") == "0" and "auto:3" or "0"
end
Keymap("n", "<leader>tf", ToggleFoldColumn, "Show/hide fold column")

-- Moverse entre buffers:
Keymap("n", "<leader>l", ":bnext<CR>", "Ir al siguiente buffer")
Keymap("n", "<leader>h", ":bprevious<CR>", "Ir al buffer anterior")
Keymap("n", "<leader>db", ":bp<bar>sp<bar>bn<bar>bd<CR>", "Borrar el buffer actual")
Keymap("n", "<leader>dB", "<CMD>bd<CR>", "Borrar el buffer actual y cerrar ventana")

-- Regresar al archivo anterior "go back"
Keymap("n", "<leader>gb", "<C-^>", "Regresa al buffer anterior")

-- Regresar a la posición del último insert
Keymap("n", "<C-i>", "`^", "Go to the last cursor position in Insert mode")

-- Centrar vista al hacer scroll
Keymap("n", "<C-d>", "<C-d>zz")
Keymap("n", "<C-u>", "<C-u>zz")

-- Centrar vista al hacer búsquedas
Keymap("n", "n", "nzzzv")
Keymap("n", "N", "Nzzzv")

-- quick-list y location-list
Keymap("n", "<C-n>", "<cmd>cnext<CR>zz", "Next quick-list element")
Keymap("n", "<C-p>", "<cmd>cprev<CR>zz", "Prev quick-list element")
-- Keymap("n", "<leader>k", "<cmd>lnext<CR>zz", "Next location-list element")
-- Keymap("n", "<leader>j", "<cmd>lprev<CR>zz", "Prev location-list element")

-- Registros y clipboard del sistema
Keymap({"n", "v"}, "<leader>y", "\"+y", "Copia al clipboard del sistema")
Keymap("x", "<leader>p", "\"_dP", "Pegar sin borrar el registro")
Keymap({"n", "v"}, "<leader>P", "<ESC>o<ESC>\"+p", "Pegar desde \" en nueva línea")

-- Evitar entrar Ex mode (no confundir con Ex de explorer)
Keymap("n", "Q", "")

-- Cambiar al modo normal desde el modo terminal
Keymap("t", "<c-n>", [[<c-\><c-n>]])

-- Dar permisos de ejecución al buffer actual si está en la lista
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
Keymap("n", "<leader>gx", chmod_exe, "Dar permisos de ejecución al buffer actual")

-- Atajos a configuraciones
Keymap("n", "<leader>CG", ":e" .. MyConfigPath .. "globals.lua<CR>", "Configuraciones de func y var globales")
Keymap("n", "<leader>CM", ":e" .. MyConfigPath .. "mappings.lua<CR>", "Configuraciones de mappings/teclas")
Keymap("n", "<leader>CP", ":e" .. MyConfigPath .. "plugins.lua<CR>", "Configuraciones de plugins")
Keymap("n", "<leader>CS", ":e" .. MyConfigPath .. "settings.lua<CR>", "Configuraciones globales de nvim")
Keymap("n", "<leader>Cs", ":e" .. MyConfigPath .. "snippets<CR>", "Configuraciones de snippets")
Keymap("n", "<leader>CL", ":e" .. MyPluginConfigPath .. "lsp.lua<CR>", "Configuraciones de servidores lsp")

-- Cambiar dirección de las flechas en los wildmenu (prompt de nvim)
vim.cmd([[
    cnoremap <expr> <Up>    wildmenumode() ? '<Left>'  : '<Up>'
    cnoremap <expr> <Down>  wildmenumode() ? '<Right>' : '<Down>'
    cnoremap <expr> <Left>  wildmenumode() ? '<Up>'    : '<Left>'
    cnoremap <expr> <Right> wildmenumode() ? '<Down>'  : '<Right>'
]])

-- Guardar y cargar sesión
if vim.g.sessions_dir ~= nil then
    exec("exec 'nnoremap <Leader>ss :mks! ' . "..
        "g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
    exec("exec 'nnoremap <Leader>so :so ' . "..
        "g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'", true)
end

-- Python runner
local autocmd = function(filetype, cmd)
    vim.api.nvim_create_autocmd(
        {"FileType"}, {pattern = filetype, command = cmd}
    )
end

autocmd("python", [[noremap <leader>rr :! python __main__.py<CR>]])
