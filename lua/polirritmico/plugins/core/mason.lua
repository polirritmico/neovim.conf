--- Mason package manager for non-nvim tools

return {
    "williamboman/mason.nvim",
    build = { ":MasonUpdate" },
    config = true,
    lazy = false,
}
