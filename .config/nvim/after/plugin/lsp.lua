-- LSP
if type(packer_plugins) ~= "table" or packer_plugins["lsp-zero.nvim"] == nil then
	return
end

local lsp = require('lsp-zero').preset({})

-- Agregar opciones
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr}

    vim.keymap.set(
        {"n", "x"}, "gq",
        function()
            vim.lsp.buf.format({async = false, timeout_ms = 5000})
        end,
        opts
    )
end)

-- Instalar lenguajes automáticamente
lsp.ensure_installed({
    "bashls",   -- Bash
    "cmake",    -- Make
    "lua_ls",   -- Lua
    "pylsp",    -- Python
})

lsp.setup()

require("lspconfig").lua_ls.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"},
            },
        },
    },
}

-- Ajuste de teclas:
local cmp = require("cmp")
cmp.setup({
    mapping = {
        -- Aceptar sugerencia seleccionada
        ["<C-j>"] = cmp.mapping.confirm({select = false}),
    }
})
