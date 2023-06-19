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

-- Solo el número resaltado, no la línea
--vim.api.nvim_set_hl(0, "Cursorline", {guibg=NONE})

