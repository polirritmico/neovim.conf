local h = require("utils").helpers

--- Ruff
---@type vim.lsp.ClientConfig
return {
  cmd = { h.local_or_global("ruff", "/.venv/bin/"), "server" },
  init_options = {
    settings = {
      lineLength = 88,
      lint = {
        ignore = { "E501" },
      },
    },
  },
  capabilities = {
    general = {
      positionEncodings = { "utf-16" },
      referencesProvider = false,
    },
  },
}
