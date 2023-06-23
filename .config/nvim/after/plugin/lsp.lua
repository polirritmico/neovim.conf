-- LSP
local plugin_name = "lsp-zero.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local lsp = require('lsp-zero').preset({"recommended"})

-- Evita cargar el LSP en archivos markdown
--lsp.skip_server_setup({"markdown"})

-- Agregar opciones
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr}

    -- Teclas default de lsp-zero
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.keymap.set('n', '<F1>', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set(
        {'n', 'x'}, '<F3>',
        '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts
    )
    vim.keymap.set(
        {"n", "x"}, "gq",
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
