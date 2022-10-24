-- Python
--
local lsp_flags = {
  debounce_text_changes = 150,
}
require("lspconfig")["pylsp"].setup{
    on_attach = function()
    vim.keymap.set({"n"}, "<leader>sk", vim.lsp.buf.hover, {buffer = 0})
    vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>st", vim.lsp.buf.type_definition, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>si", vim.lsp.buf.implementation, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>se", vim.diagnostic.goto_next, {buffer = 0})
    end,
    flags = lsp_flags,
}
require("lspconfig")["clangd"].setup{
    on_attach = function()
    vim.keymap.set({"n"}, "<leader>sk", vim.lsp.buf.hover, {buffer = 0})
    vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>st", vim.lsp.buf.type_definition, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>si", vim.lsp.buf.implementation, {buffer = 0})
    vim.keymap.set({"n"}, "<leader>se", vim.diagnostic.goto_next, {buffer = 0})
    end,
    flags = lsp_flags,
}
