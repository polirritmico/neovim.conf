-- yamlls
---@type vim.lsp.ClientConfig
---@diagnostic disable: missing-fields
return {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
}
