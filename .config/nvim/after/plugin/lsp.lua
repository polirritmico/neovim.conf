-- LSP
local plugin_name = "lsp-zero.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local lsp = require('lsp-zero').preset({})

-- Instalar lenguajes automáticamente
lsp.ensure_installed({ "bashls", "jsonls", "lua_ls", "pylsp" })

-- Agregar opciones
lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr }

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
        { 'n', 'x' }, '<F3>',
        '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts
    )
end)

lsp.setup()

-- Ajuste tecla de selección de sugerencias
local cmp = require("cmp")
cmp.setup({ mapping = { ["<C-j>"] = cmp.mapping.confirm({ select = true }) } })

-- Ajuste de errores y advertencias
require("lspconfig").pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = false },
                --isort = { enabled = true, profile = "black" },
                pycodestyle = {
                    maxLineLength = 88,
                    ignore = { "E265", "E501", "W391", "W503" }
                }
            }
        }
    }
}
-- Ajustamos la variable global vim para evitar warnings en la configuración
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "Check_loaded_plugin" },
            },
        },
    },
}
