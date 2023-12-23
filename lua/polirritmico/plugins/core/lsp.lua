-- full config in ../setups/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        { "folke/neodev.nvim", config = true },
    },
    config = true,
    main = MyUser .. ".plugins.setups.lsp",
}
