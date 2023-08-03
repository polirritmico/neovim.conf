-- LSP
if not Check_loaded_plugin("lsp-zero.nvim") then return end

local lsp = require('lsp-zero').preset()

-- Servidores por defecto
lsp.ensure_installed({"bashls", "clangd", "lua_ls", "pylsp"})

-- Cuando se adjunta el servidor LSP a algun buffer se ejecuta esta función
lsp.on_attach(function(_, bufnr)
    -- :h lsp-zero-keybindings
    local opts = {buffer = bufnr, remap = false}
    lsp.default_keymaps(opts)
    -- opts.desc = "LSP: Open diagnostic float panel"
    vim.keymap.set("n", "<F1>", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
end)

-- Configuraciones globales de servidores
lsp.configure("pylsp",{
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                pycodestyle = {
                    maxLineLength = 88,
                    ignore = { "E265", "E501", "W391", "W503" }
                }
            }
        }
    }
})

-- Configuraciones lua para nvim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-------------------------------------------------------------------------------
if Check_loaded_plugin("mason-tool-installer.nvim") then
    require("mason-tool-installer").setup({
        ensure_installed = { "debugpy", },
        run_on_start = true,
    })
end

-------------------------------------------------------------------------------
-- Autocompletado
local cmp = require("cmp")

cmp.setup({
    -- Ajuste tecla de selección de sugerencias
    mapping = { ["<C-j>"] = cmp.mapping.confirm({ select = true }) },
    sources = {
        { name = "path" },
        { name = "luasnip", option = {use_show_condition = false} },
        { name = "nvim_lsp" },
        { name = "cmp_luasnip" },
        { name = "buffer",  keyword_length = 3 },
    },
    -- Agregar borde a ventana emerge
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})

-------------------------------------------------------------------------------
-- LSP_signature.
-- Ayuda flotante de los argumentos de una función al usarla
if Check_loaded_plugin("lsp_signature.nvim") then
    local config = {
        floating_window_above_cur_line = true,
        close_timeout = 2000,
        hint_prefix = " ",
        toggle_key = "<A-i>",
        toggle_key_flip_floatwin_setting = true,
    }
    require("lsp_signature").setup(config)
end

-------------------------------------------------------------------------------
-- null-ls
if Check_loaded_plugin("null-ls.nvim") then
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = false,
        on_attach = function(client, bufnr)
            if vim.bo.filetype == "python" then
                require("lsp-zero").async_autoformat(client, bufnr)
            end
        end,
        sources = {
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.black,
        }
    })
end
