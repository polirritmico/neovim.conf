--- Tables automatization

return {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    init = function()
        -- Avoid polluting <leader>t mappings. (keep <leader>tm for enable)
        vim.g.table_mode_disable_tableize_mappings = 1
    end,
    config = function()
        vim.g.table_mode_corner = "|"
    end,
}
