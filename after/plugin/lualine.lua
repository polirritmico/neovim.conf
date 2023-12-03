-- Lualine
if not Check_loaded_plugin("lualine.nvim") then return end

-- Si está disponible usa Monokai y en caso contrario usa material.
local cfg_theme = Check_loaded_plugin("monokai-nightasty.nvim") and "monokai-nightasty" or "material"
require("lualine").setup({
    options = {
        theme = cfg_theme,
    },
    sections = {
        lualine_c = {
            function() return vim.fn.ObsessionStatus("", "") end,
            { "filename", path = 4, shorting_target = 45 }
        }
    },
})
