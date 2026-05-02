-- texlab
---@type vim.lsp.ClientConfig
---@diagnostic disable: missing-fields
return {
  settings = {
    texlab = {
      rootDirectory = ".",
      latexFormatter = "texlab",
    },
  },
}
