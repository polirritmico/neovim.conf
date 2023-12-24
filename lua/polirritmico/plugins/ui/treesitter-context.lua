-- Shows code context on the top (func, classes, etc.)

return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    lazy = true,
    opts = {
        min_window_height = 10, -- in lines
        max_lines = 10, -- max number of lines to show for a single context
    }
}
