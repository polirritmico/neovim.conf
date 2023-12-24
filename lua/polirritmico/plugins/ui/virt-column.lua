--- Custom vertical width column/ruler

return {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        char = "┊"
    }
}
