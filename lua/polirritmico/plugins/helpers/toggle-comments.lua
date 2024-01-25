--- Toggle comments on the selected or current line
return {
  "numToStr/Comment.nvim",
  config = true,
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
}
