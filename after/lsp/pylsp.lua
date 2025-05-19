--- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
return {
  -- cmd = { "pylsp" },
  -- filetypes = { "python" },
  -- root_markers = {
  --   "pyproject.toml",
  --   "setup.py",
  --   "setup.cfg",
  --   "requirements.txt",
  --   "Pipfile",
  --   ".git",
  -- },
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = true },
        pylsp_mypy = { enabled = true },
        pycodestyle = {
          maxLineLength = 88,
          ignore = { "E203", "E265", "E501", "E704", "W391", "W503" },
        },
        rope_completion = {
          enabled = true,
          eager = false, -- Resolve documentation and detail eagerly.
        },
      },
    },
  },
}
