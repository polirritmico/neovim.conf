--- Intelephense
---@type vim.lsp.ClientConfig
return {
  cmd = { "intelephense" },
  init_options = {
    globalStoragePath = vim.fn.stdpath("cache") .. "/intelephense",
  },
}
