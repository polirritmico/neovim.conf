--- Language Server Protocol
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "folke/neodev.nvim", config = true },
  },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lsp = require("mason-lspconfig")

    --- Keys
    local function toggle_lsp_diag()
      if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
      else
        vim.diagnostic.disable()
      end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local buf_opts = { buffer = event.buf }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, buf_opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, buf_opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, buf_opts)
        -- vim.keymap.set({"n", "x"}, "<F3>", function() vim.lsp.buf.format({async = true}) end, buf_opts)
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, buf_opts)

        vim.keymap.set("n", "<F1>", vim.diagnostic.open_float, buf_opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf_opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf_opts)
        vim.keymap.set({ "n", "v" }, "<leader>gH", toggle_lsp_diag, buf_opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, buf_opts)
      end,
    })

    --- Servers configurations `:h lspconfig-configuration`
    local function default_setup(server)
      lspconfig[server].setup({})
    end

    local function config_clangd()
      lspconfig.clangd.setup({
        cmd = { "clangd", "--fallback-style=WebKit" },
      })
    end

    local function config_lua_ls()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })
    end

    local function config_pylsp()
      lspconfig.pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              black = { enabled = true },
              pylsp_mypy = { enabled = true },
              pycodestyle = {
                maxLineLength = 88,
                ignore = { "E203", "E265", "E501", "W391", "W503" },
              },
            },
          },
        },
      })
    end

    local function config_texlab()
      lspconfig.texlab.setup({
        settings = { texlab = { latexFormatter = "texlab" } },
      })
    end

    local lsp_defaults = lspconfig.util.default_config
    lsp_defaults.capabilities = vim.tbl_deep_extend(
      "force",
      lsp_defaults.capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Apply servers configurations
    mason_lsp.setup({
      ensure_installed = { "bashls", "clangd", "lua_ls", "pylsp" },
      handlers = {
        default_setup,
        clangd = config_clangd,
        lua_ls = config_lua_ls,
        pylsp = config_pylsp,
        texlab = config_texlab,
      },
    })

    -- Add borders to LspInfo
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Add borders to Hover when Noice is not in the Lazy plugins spec.
    if not require("lazy.core.config").spec.plugins["noice.nvim"] then
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    end
  end,
}
