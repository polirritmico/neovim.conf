--- Shows code context on the top (func, classes, etc.)
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    min_window_height = 10, -- in lines
    max_lines = 3, -- max number of lines of the header context
  },
}
