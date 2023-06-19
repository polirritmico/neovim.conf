-- LSP
if type(packer_plugins) ~= "table" or packer_plugins["lsp-zero.nvim"] == nil then
	return
end

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.skip_server_setup({"markdown"})

lsp.setup()
