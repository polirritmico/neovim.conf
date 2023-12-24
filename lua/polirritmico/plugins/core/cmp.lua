--- Auto completion
-- full config in ../setups/cmp.lua

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",  -- snippets server
        "saadparwaiz1/cmp_luasnip",  -- custom snippets
        "windwp/nvim-autopairs",
    },
    config = true,
    event = "InsertEnter",
    main = MyUser .. ".plugins.setups.cmp",
}
