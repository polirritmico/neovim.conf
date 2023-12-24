--- Indentation guide lines

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        indent = {
            char = {"│"},
            smart_indent_cap = false,
        },
        scope = { enabled = false },
    }
}
