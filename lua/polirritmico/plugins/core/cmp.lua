--- Auto completion
-- full config in ../setups/cmp.lua

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",  -- snippets server
        "saadparwaiz1/cmp_luasnip",  -- custom snippets
        "windwp/nvim-autopairs",
    },
    event = "VeryLazy",
    main = MyUser .. ".plugins.setups.cmp",
    config = true,
}
