-- Lazy plugin file ../core/lsp.lua

local lspconfig = require("lspconfig")
local mason_lsp = require("mason-lspconfig")

M = {}

--------------------------------
-- LSP servers configurations --
--------------------------------

-- Default
local function default_setup(server)
    lspconfig[server].setup({})
end

-- Lua
local function config_lua_ls()
    lspconfig.lua_ls.setup({ settings = { Lua = {
        workspace = {
            checkThirdParty = false,
        },
    }}})
end

-- Python
local function config_pylsp()
    lspconfig.pylsp.setup({ settings = { pylsp = {
        plugins = {
            black = { enabled = true },
            pylsp_mypy = { enabled = true, },
            pycodestyle = {
                maxLineLength = 88,
                ignore = { "E203", "E265", "E501", "W391", "W503" },
            },
        },
    }}})
end

-------------------------------------------------------------------------------

function M.setup()
    local function toggle_lsp_diagnostic()
        if vim.diagnostic.is_disabled() then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
            local opts = {buffer = event.buf}
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
            vim.keymap.set({"n", "x"}, "<F3>", function() vim.lsp.buf.format({async = true}) end, opts)
            vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)

            vim.keymap.set("n", "<F1>", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set({"n", "v"}, "<leader>gH", toggle_lsp_diagnostic, opts)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
        end
    })

    -- Apply servers configurations
    mason_lsp.setup({
        ensure_installed = { "bashls", "clangd", "lua_ls", "pylsp", },
        handlers = {
            default_setup,
            lua_ls = config_lua_ls,
            pylsp = config_pylsp,
        },
    })

    ---------------------------------------------------------------------------
    -- Add borders to LspInfo
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Add borders to Hover
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
    )
end

return M
