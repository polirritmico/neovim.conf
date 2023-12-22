--- Lualine: Status bar

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "polirritmico/monokai-nightasty.nvim",
    },
    opts = {
        options = {
            theme = "monokai-nightasty"
        },
        sections = {
            lualine_c = {
                function() return vim.fn.ObsessionStatus("", "") end,
                { "filename", path = 4, shorting_target = 45 }
            },
        },
    },
}
