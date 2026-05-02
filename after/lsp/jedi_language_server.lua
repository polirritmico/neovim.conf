local h = require("utils").helpers

---@type vim.lsp.ClientConfig
return {
  cmd = { h.local_or_global("jedi-language-server", "/.venv/bin/") },
  on_attach = function(client)
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.renameProvider = false
  end,
  capabilities = {
    general = {
      positionEncodings = { "utf-16" },
    },
  },
}
