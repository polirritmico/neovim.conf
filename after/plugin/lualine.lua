-- Lualine
if not Check_loaded_plugin("lualine.nvim") then return end

-- Load monokai.nvim theme if its loaded or default to material
local cfg_theme = Check_loaded_plugin("monokai.nvim") and "monokai" or "material"
require("lualine").setup({
    options = {
        theme = cfg_theme,
    }
})

