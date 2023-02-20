local opt = vim.opt
local api = vim.api


------------
-- EDITOR --
------------

-- FUNCIONAMIENTO --
vim.g.mapleader = " "       -- Tecla líder a espacio
opt.wrap = true             -- Divide líneas largas
opt.errorbells = false      -- Deshabilita anuncios de errores
opt.mouse = "a"             -- Habilita el soporte del ratón
opt.timeout = true          -- Tiempo de espera de las combinaciones de teclas
opt.timeoutlen = 2000       -- 1000ms por defecto

opt.hlsearch = false        -- Deshabilita el highligh en las búsquedas
opt.incsearch = true        -- Muestra los resultados mientras se busca
--api.nvim_create_autocmd({ "BufWritePre" }, { -- Elimina espacios sobrantes al
--  pattern = { "*" },                         -- guardar un archivo
--  command = [[%s/\s\+$//e]],
--})


-- INDENTACIÓN --
opt.tabstop = 4             -- Cantidad de espacios de la tecla tab
opt.softtabstop = 4         -- Cantidad de espacios del "indentado visual"
opt.shiftwidth = 4          -- Cantidad de espacios del autoindentado
opt.expandtab = true        -- Reemplaza tab por espacios en el modo Insertar
--opt.shiftround = true       -- Aproxima la indent. en múltiplos de shiftwidth
opt.smartindent = true      -- Autoindenta al agregar una nueva línea

opt.cindent = true          -- Indenta comentarios al inicio de las líneas
opt.cinkeys = opt.cinkeys - "0#" -- Ídem.


-- PLEGADO DE CÓDIGO --
--opt.foldmethod = "indent"   -- El tipo de plegado que usa la ventana actual
opt.foldmethod = "manual"   -- El tipo de plegado que usa la ventana actual
opt.foldnestmax = 2         -- El máximo de pliegues anidados
opt.foldenable = false      -- Evita plegado al abrir un archivo


-- IDIOMA --
api.nvim_exec("language en_US.utf8", true)


-- RESPALDOS --
opt.undofile = false        -- Deshabilitado: Da error si no se guarda al salir
opt.backup = false          -- Ídem.


-- SESIONES --
opt.wildmenu = true         -- Completado de comandos avanzado
opt.wildmode = "full"       -- :help wildmode
vim.g.sessions_dir = "~/.local/share/nvim/sessions"


-- CTAGS --
-- Crea "tags" del archivo (requiere ctags instalado en el sistema) para poder
-- ir rápidamente a definiciones incluso en archivos diferentes al actual.
--api.nvim_command("command! MakeTags !ctags -R .")



----------------
-- CONFIG GUI --
----------------

-- OPCIONES --
opt.relativenumber = true   -- Muestra númeras de línea relativos
opt.number = true           -- Muestra el número de línea actual en lugar de 0
opt.cursorline = false      -- Subrraya la línea del cursor
opt.colorcolumn = "80"      -- Límite de columna guía


