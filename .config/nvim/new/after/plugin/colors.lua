function MyColors(color)
	color = color or "vim-monokai-tasty"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "Normal", { bg = "none", fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.opt.termguicolors = true
end

MyColors()

-- COLORES --
--opt.syntax = "ON"           -- Coloreo de sintaxis básico
--opt.background=dark         -- Dark o light
vim.opt.cursorline = true       -- Resaltado línea actual
vim.api.nvim_set_hl(0,          -- Solo el número resaltado, no la línea
        "Cursorline",
        {guibg=NONE})
