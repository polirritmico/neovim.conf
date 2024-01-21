-- Automatically add closing tags for HTML and JSX
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = true,
}
