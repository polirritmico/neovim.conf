-- LSP
local plugin_name = "lsp-zero.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local lsp = require('lsp-zero').preset({ "recommended" })

-- Evita cargar el LSP en archivos markdown
--lsp.skip_server_setup({"markdown"})

-- Agregar opciones
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr }

    -- Teclas default de lsp-zero
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<F1>', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
    vim.keymap.set(
        { 'n', 'x' }, '<F3>',
        '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts
    )
    vim.keymap.set(
        { "n", "x" }, "gq",
        '<cmd>lua vim.lsp.buf.format({async = false, timeout_ms = 5000})', opts
    )
end)

-- Instalar lenguajes automáticamente
lsp.ensure_installed({
    "bashls",
    "cmake",
    "jsonls",
    "lua_ls",
    "pylsp",
})

lsp.setup()

-- Ajustamos la variable global vim para evitar warnings en la configuración
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
}

-- Ajuste de errores y advertencias
require("lspconfig").pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    maxLineLength = 88,
                    ignore = { "E265", "E501", "W391" }
                }
            }
        }
    }
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
        ["<C-j>"] = cmp.mapping.confirm({ select = true }),
    },
})
