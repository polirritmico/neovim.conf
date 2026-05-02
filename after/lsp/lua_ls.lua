-- lua_ls
---@type vim.lsp.ClientConfig
---@diagnostic disable: missing-fields
return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
    },
  },
}
