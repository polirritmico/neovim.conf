-- Vim Monokai Tasty
if type(packer_plugins) ~= "table" or packer_plugins["vim-monokai-tasty"] == nil then
	return
end

-- Permite cursivas.
-- IMPORTANTE: Debe ir antes de colorscheme
vim.g.vim_monokai_tasty_italic = 1

-- Cargar el tema
vim.api.nvim_command("colorscheme vim-monokai-tasty")

-- Colores
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.cursorline = true

-- Fondo transparente ventanas flotantes
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Fondo transparente global y texto blanco
vim.cmd("highlight! Normal guibg=NONE ctermbg=NONE")

-- Color de mensajes warning de LSP
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {fg="#ff9700"})

-- Línea actual
-- Solo el número resaltado, no la línea
--vim.api.nvim_set_hl(0, "Cursorline", {guibg=NONE})
-- Cambiar color al resaltado de línea
--vim.cmd("highlight! Cursorline guibg='#2b2b2b'")
-- Línea actual subrayada
--vim.cmd("highlight Cursorline gui=underline cterm=underline ctermfg=None guifg=None")

