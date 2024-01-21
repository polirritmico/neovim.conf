--- Mason package manager for non-nvim tools
return {
  "williamboman/mason.nvim",
  build = { ":MasonUpdate" },
  cmd = "Mason",
  keys = {
    { "<leader>Cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  opts = {
    ensure_installed = {
      "bash-language-server", -- Bash language server
      "clangd", -- LSP for C/C++
      "lua-language-server", -- Lua language server
      "stylua", -- Lua code formatter
      "python-lsp-server", -- fork of python-language-server
      -- "black", -- Python formatter
      -- "isort", -- Python imports formatter
      "prettier", -- Formater for css, html, json, javascript, yaml and more.
    },
    ui = { border = "rounded" },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    -- trigger FileType event to try loading newly installed servers
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
