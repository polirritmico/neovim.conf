-- Monokai Nvim Theme
if not Check_loaded_plugin("monokai.nvim") then return end

-- Resaltado de la línea actual
vim.opt.cursorline = true

require("monokai").setup({
    transparent = true,
    lualine_bold = true,
    styles = {
        keywords = { italic = false },
    },
})

-- Cargar el tema
vim.cmd("colorscheme monokai")

-- Añadir atajo para conmutar tema oscuro/claro
Keymap({"n"}, "<leader>tc", function() print("Toggle theme") end, "Monokai: Toggle dark/light theme")
