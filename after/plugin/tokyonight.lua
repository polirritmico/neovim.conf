-- Tokyo Night Theme
if not Check_loaded_plugin("tokyonight.nvim") then return end

-- Resaltado de la línea actual
vim.opt.cursorline = true

require("tokyonight").setup({
    transparent = true,
    lualine_bold = true,
    styles = {
        keywords = { italic = false },
    },
})

-- Cargar el tema
vim.cmd("colorscheme tokyonight")
