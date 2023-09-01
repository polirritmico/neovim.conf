local api = vim.api
local opt = vim.opt

--------------------
-- FUNCIONAMIENTO --
--------------------

-- Idioma
api.nvim_exec("language en_US.utf8", true)

-- Generales
opt.errorbells = false      -- Deshabilita anuncios de errores
opt.mouse = "a"             -- Habilita el soporte del ratón
opt.timeout = true          -- Tiempo de espera de las combinaciones de teclas
opt.timeoutlen = 2000       -- 1000ms por defecto

-- Búsquedas
opt.ignorecase = true       -- Al buscar ignora la capitalización
opt.incsearch = true        -- Muestra los resultados mientras se busca
opt.magic = true            -- Patrones regex estándar
opt.path:append("**")       -- Búsquedas en subdirectorios con tab completion
opt.smartcase = true        -- Se activa solo si hay mayúsculas en la búsqueda

-- Entrar en modo insert al abrir :terminal
vim.cmd([[autocmd TermOpen * startinsert]])

-- Guarda la posición del cursor en el archivo.
vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 0 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])

-- Respaldos
opt.backup = false          -- No usar archivos de respaldo. Molesta mucho.
opt.undofile = false        -- Deshabilitado: Da error si no se guarda al salir
-- opt.swapfile = false        -- No crear archivo swap por buffer
-- opt.updatecount = 0         -- No escribir en el archivo swap cada N chars

-- Wildmenu
opt.wildmenu = true         -- Completado de comandos avanzado
opt.wildmode = "full"       -- :help wildmode


----------------
-- APARIENCIA --
----------------

opt.cmdheight = 0           -- Elimina la linea de comandos bajo la barra
opt.colorcolumn = {80,100}  -- Límite de columnas guía
opt.cursorline = false      -- Subrraya la línea del cursor
opt.equalalways = true      -- Ajusta ventanas al mismo tamaño al cerrar una.
opt.hlsearch = false        -- Deshabilita el highligh después de las búsquedas
opt.laststatus = 3          -- Status bar global
opt.number = true           -- Muestra el número de línea actual en lugar de 0
opt.relativenumber = true   -- Muestra númeras de línea relativos
opt.scrolloff = 6           -- Para hacer scroll con un margen en los bordes
opt.showmode = false        -- Muestra el estado en el área de comandos
opt.title = true            -- Ajusta el nombre de la ventana

-- Resalta el texto copiado
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

-- Deshabilitar entrada del menu "How-to disable mouse"
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse | aunmenu PopUp.-1-]])


------------
-- CÓDIGO --
------------

opt.wrap = false            -- Divide líneas largas
opt.textwidth = 80          -- Ajusta las líneas hasta este límite horizontal

-- Indentación
opt.autoindent = true       -- Indenta en base a la línea anterior
opt.cindent = true          -- Indenta comentarios al inicio de las líneas
opt.cinkeys = opt.cinkeys - "0#" -- Ídem.
opt.expandtab = true        -- Reemplaza tab por espacios en el modo Insertar
opt.shiftround = true       -- Aproxima el indentado en múltiplos de shiftwidth
opt.shiftwidth = 4          -- Cantidad de espacios usados por indent y unindent
opt.smartindent = true      -- Autoindenta al agregar una nueva línea
opt.smarttab = true         -- Tab sigue tabstop, shiftwidth y softtabstop
opt.softtabstop = 4         -- Editar como si los tabs fueran de 4 espacios
opt.tabstop = 4             -- Cantidad de espacios del indentado en pantall

-- Plegado de código
opt.foldmethod = "expr"     -- Tipo de plegado (expr, indent, manual)
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Definición de la expr
opt.foldenable = false      -- Deshabilita el plegado al abrir el archivo
opt.foldlevelstart = 99     -- No plegar todo el código al usar el plegado
opt.foldlevel = 1           -- Plegar solo 1 nivel?
opt.foldminlines = 1        -- Mínimo nivel de plegado
opt.foldnestmax = 3         -- Máximo nivel de plegado anidado
opt.foldcolumn = "0"        -- Habilita la columna de plegado "0-9", "auto:1-9"
opt.foldtext = "v:lua.CustomFoldText()" -- Ajusta texto del plegado (en globals.lua)
opt.fillchars:append({fold = " "})      -- Quitar puntos después de foldtext


------------
-- CUSTOM --
------------

-- Trabajar con un buffer en 2 ventanas tipo columnas.
vim.cmd([[
    command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
        \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
]])
