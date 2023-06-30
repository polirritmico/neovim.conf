local opt = vim.opt
local api = vim.api

------------
-- EDITOR --
------------

-- FUNCIONAMIENTO --
opt.wrap = false            -- Divide líneas largas
opt.errorbells = false      -- Deshabilita anuncios de errores
opt.mouse = "a"             -- Habilita el soporte del ratón
opt.timeout = true          -- Tiempo de espera de las combinaciones de teclas
opt.timeoutlen = 2000       -- 1000ms por defecto
opt.path:append("**")       -- Búsquedas en subdirectorios con tab completion
opt.incsearch = true        -- Muestra los resultados mientras se busca
opt.scrolloff = 6           -- Para hacer scroll con un margen en los bordes
opt.showmode = false        -- Muestra el estado en el área de comandos


-- INDENTACIÓN --
opt.tabstop = 4             -- Cantidad de espacios de la tecla tab
opt.shiftwidth = 0          -- Cantidad de espacios del autoindentado
opt.softtabstop = 4         -- Cantidad de espacios del "indentado visual"
opt.shiftround = true       -- Aproxima la indent. en múltiplos de shiftwidth
opt.expandtab = true        -- Reemplaza tab por espacios en el modo Insertar
opt.smartindent = true      -- Autoindenta al agregar una nueva línea

opt.cindent = true          -- Indenta comentarios al inicio de las líneas
opt.cinkeys = opt.cinkeys - "0#" -- Ídem.


-- PLEGADO DE CÓDIGO --
--opt.foldmethod = "indent"   -- El tipo de plegado que usa la ventana actual
--opt.foldmethod = "manual"   -- El tipo de plegado que usa la ventana actual
--opt.foldnestmax = 2         -- El máximo de pliegues anidados
--opt.foldenable = false      -- Evita plegado al abrir un archivo


-- IDIOMA --
api.nvim_exec("language en_US.utf8", true)


-- RESPALDOS --
opt.undofile = false        -- Deshabilitado: Da error si no se guarda al salir
opt.backup = false          -- Ídem.


-- SESIONES --
opt.wildmenu = true         -- Completado de comandos avanzado
opt.wildmode = "full"       -- :help wildmode
vim.g.sessions_dir = "~/.local/share/nvim/sessions"



----------------
-- CONFIG GUI --
----------------

-- OPCIONES --
opt.relativenumber = true   -- Muestra númeras de línea relativos
opt.number = true           -- Muestra el número de línea actual en lugar de 0
opt.cursorline = false      -- Subrraya la línea del cursor
opt.colorcolumn = {80,100}  -- Límite de columnas guía
opt.hlsearch = false        -- Deshabilita el highligh en las búsquedas

-- Guarda la posición del cursor en el archivo.
-- (Autocommand copiado de la documentación. Por defecto en algunas distros.)
vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 0 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])

-- Abre la ayuda en la ventana actual (código de help-curwin).
--vim.cmd([[
--    let s:did_open_help = v:false
--    function s:HelpCurwin(subject) abort
--        let mods = 'silent noautocmd keepalt'
--        if !s:did_open_help
--            execute mods .. ' help'
--            execute mods .. ' helpclose'
--            let s:did_open_help = v:true
--        endif
--        if !empty(getcompletion(a:subject, 'help'))
--            execute mods .. ' edit ' .. &helpfile
--            set buftype=help
--        endif
--        return 'help ' .. a:subject
--    endfunction

--    command -bar -nargs=? -complete=help HelpCurwin execute s:HelpCurwin(<q-args>)
--]])
