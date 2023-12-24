-- full config in ../setups/lsp.lua

-- return {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--         "williamboman/mason.nvim",
--         "williamboman/mason-lspconfig.nvim",
--         { "folke/neodev.nvim", config = true },
--     },
--     config = true,
--     event = "VeryLazy",
--     main = MyUser .. ".plugins.setups.lsp",
-- }

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        { "folke/neodev.nvim", opts = {} },
        "mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = true,
    main = MyUser .. ".plugins.setups.lsp",
}
