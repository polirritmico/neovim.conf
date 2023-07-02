-- LSP
local plugin_name = "lsp-zero.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local lsp = require('lsp-zero').preset({"recommended"})

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
    }
})

-- Ajuste de errores y advertencias
require("lspconfig").pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
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

-------------------------------------------------------------------------------
-- LSP_signature.
-- Para mostrar una ventana flotante al escribir argumentos de funciones
if not Check_loaded_plugin("lsp_signature.nvim") then
    return
end

local config = {
    floating_window = true,                  -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true,   -- try to place the floating above the current line when possible
    close_timeout = 2000,                    -- close floating window after ms when laster parameter is entered
    hint_enable = true,                      -- virtual hint enable
    --     ↕  ⇕         
    hint_prefix = " ",                    -- Panda for parameter,  NOTE: For the terminal not support emoji, might crash
    hint_scheme = "String",
    handler_opts = { border = "rounded" },   -- double, rounded, single, shadow, none, or a table of borders
    always_trigger = false,                  -- sometime show signature on new line or in middle of parameter can be confusing, set it false for #58
    auto_close_after = nil,                  -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {},                -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    transparency = nil,                      -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36,                       -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black',                  -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200,                    -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = "<A-i>",                    -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    toggle_key_flip_floatwin_setting = true, -- true: toggle float setting after toggle key pressed
    select_signature_key = nil,              -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil,                   -- imap, use nvim_set_current_win to move cursor between current win and floating
}

require("lsp_signature").setup(config)
