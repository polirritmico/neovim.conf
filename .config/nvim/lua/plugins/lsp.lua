-- LSP config

local servers = { "pylsp", "clangd", }

for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup{
    on_attach = function()
      vim.keymap.set({"n"}, "gD", vim.lsp.buf.declaration, {buffer = 0})
      vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition, {buffer = 0})
      vim.keymap.set({"n"}, "gi", vim.lsp.buf.implementation, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>sk", vim.lsp.buf.hover, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>st", vim.lsp.buf.type_definition, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>sE", vim.diagnostic.goto_prev, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>sr", vim.lsp.buf.rename, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>sd", vim.diagnostic.show, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>sD", vim.diagnostic.hide, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>si", vim.lsp.buf.implementation, {buffer = 0})
      vim.keymap.set({"n"}, "<leader>se", vim.diagnostic.goto_next, {buffer = 0})
      vim.keymap.set({"n", "v"}, "<leader>sf", vim.lsp.buf.format, {buffer = 0})
      end,
    flags = lsp_flags,
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        -- Enable virtual text, override spacing to 4
        --virtual_text = {spacing = 4},
        --signs = true,
        --update_in_insert = false
    })

