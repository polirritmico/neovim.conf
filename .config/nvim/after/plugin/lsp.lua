-- LSP
if type(packer_plugins) ~= "table" or packer_plugins["lsp-zero.nvim"] == nil then
	return
end

local lsp = require('lsp-zero').preset({"recommended"})

-- Evita cargar el LSP en archivos markdown
--lsp.skip_server_setup({"markdown"})

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

-- Ajustamos la variable global vim para evitar warnings en la configuración
require("lspconfig").lua_ls.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"},
            },
        },
    },
}

local cmp = require("cmp")
--local cmp_action = require("lsp-zero").cmp_action()
--require("luasnip.loaders.from_snipmate").lazy_load()
cmp.setup({
    --sources = {
    --    {name = "nvim_lsp"},
    --    {name = "luasnip"},
    --},
    -- Ajuste de teclas:
    mapping = {
        -- Aceptar sugerencia
        ["<C-j>"] = cmp.mapping.confirm({select = true}),
    },
})
