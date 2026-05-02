local u = require("utils")

u.config.lsp_disable_jedi_completion_if_rope_is_enabled()

--- PyLSP
--- Reference: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
---@type vim.lsp.ClientConfig
return {
  cmd = { u.helpers.local_or_global("pylsp", "/.venv/bin/") },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "requirements.txt",
    ".git",
  },
  -- capabilites = { general = { offsetEncoding = "utf-16" } },
  settings = {
    pylsp = {
      plugins = {
        black = {
          enabled = true,
        },
        jedi = {
          extra_paths = { "./src" },
        },
        jedi_completion = {
          enabled = false,
        },
        pylsp_mypy = {
          python_executable = u.helpers.local_or_global("python", "/.venv/bin/"),
          enabled = true,
          dmypy = false, -- server-like mode
          live_mode = Workstation, -- mypy on demand (CPU intensive).
          config_file = u.helpers.local_or_global("pyproject.toml"),
        },
        pylsp_rope = {
          enabled = true,
          rename = true,
        },
        pycodestyle = {
          maxLineLength = 88,
          ignore = { "E203", "E265", "E501", "E704", "W391", "W503" },
        },
        rope_completion = {
          enabled = true,
          eager = false, -- Resolve documentation and detail eagerly.
        },
        rope_rename = {
          enabled = false,
        },
        ruff = {
          enabled = true,
        },
      },
    },
  },
}
