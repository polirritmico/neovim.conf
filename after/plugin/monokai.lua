-- Monokai Nvim Theme
if not Check_loaded_plugin("monokai.nvim") then return end

-- Resaltado de la línea actual
vim.opt.cursorline = true

require("monokai").setup({
    transparent = true,
    lualine_bold = true,
    day_brightness = 0.3,
    styles = {
        keywords = { italic = false },
    },
})

-- Cargar el tema
vim.cmd("colorscheme monokai")

-- Añadir atajo para conmutar tema oscuro/claro
local toggle_theme = function()
    local background = (vim.o.background == "dark") and "light" or "dark"
    if background == "dark" then
        require("monokai").setup({transparent = true})
    else
        require("monokai").setup({transparent = false})
    end
    vim.o.background = background
end
Keymap({"n"}, "<leader>tc", toggle_theme, "Monokai: Toggle dark/light theme")
