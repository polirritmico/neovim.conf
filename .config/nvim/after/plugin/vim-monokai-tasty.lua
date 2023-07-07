-- Configuraciones generales

-- Vim Monokai Tasty
local plugin_name = "vim-monokai-tasty"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- Permite cursivas. (Debe ir antes de colorscheme)
vim.g.vim_monokai_tasty_italic = 1

-- Cargar el tema
vim.api.nvim_command("colorscheme vim-monokai-tasty")

-- Colores
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- Fondo transparente ventanas flotantes (revisar bordered en LSP cmp)
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Fondo transparente global y texto blanco
vim.cmd("highlight! Normal guibg=NONE ctermbg=NONE")

-- Color de mensajes warning de LSP
--vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ff9700" })

-- Resaltar solo el número de la línea actual, no la línea
--vim.api.nvim_set_hl(0, "Cursorline", {guibg=NONE})
