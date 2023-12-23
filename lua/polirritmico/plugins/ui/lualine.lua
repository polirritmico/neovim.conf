--- Lualine: Status bar

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = function()
        local cfg_theme = #vim.fn.getcompletion("monokai-nightasty", "color") == 0
            and "material"
            or "monokai-nightasty"
        return {
            options = {
                theme = cfg_theme
            },
            sections = {
                lualine_c = {
                    function() return vim.fn.ObsessionStatus("", "") end,
                    { "filename", path = 4, shorting_target = 45 }
                },
            },
        }
    end,
}
