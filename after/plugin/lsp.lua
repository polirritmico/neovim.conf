-- LSP
if not Check_loaded_plugin("nvim-lspconfig") then return end

local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)

-- Ocultar/Mostrar diagnósticos
local toggleLspDiagnostic = function()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

-- Cuando se adjunta el servidor LSP a algun buffer se ejecuta esta función
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F1>", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({"n", "x"}, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
        vim.keymap.set({"n", "v"}, "<leader>gH", toggleLspDiagnostic, opts)
    end
})

-------------------------------------------------------------------------------
-- Mason maneja los paquetes de los servidores LSP
if not Check_loaded_plugin("mason-lspconfig.nvim") then return end


--- Configuraciones de servidores LSP
-- Default
local default_setup = function(server)
    lspconfig[server].setup({})
end

-- Lua
local config_lua_ls = function()
    lspconfig.lua_ls.setup({ settings = { Lua = {
        runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"), -- runtime path
        },
        diagnostics = { globals = {"vim"} },
        workspace = {
            checkThirdParty = false,
            library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.stdpath("config") .. "/lua"
            }
        }
    }}})
end

-- Python
local config_pylsp = function()
    lspconfig.pylsp.setup({ settings = { pylsp = {
        plugins = {
            black = { enabled = true },
            pycodestyle = {
                maxLineLength = 88,
                ignore = { "E203", "E265", "E501", "W391", "W503" }
            }
        }
    }}})
end

-- Aplicamos las configuraciones
require("mason").setup({})
require("mason-lspconfig").setup({
    -- Servidores a instalar por defecto
    ensure_installed = { "bashls", "clangd", "lua_ls", "pylsp", },
    handlers = {
        default_setup,
        lua_ls = config_lua_ls,
        pylsp = config_pylsp
    },
})


-------------------------------------------------------------------------------
-- Python debug
if Check_loaded_plugin("mason-tool-installer.nvim") then
    require("mason-tool-installer").setup({
        ensure_installed = { "debugpy", },
        run_on_start = true,
    })
end


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
-- Agrega bordes a LspInfo
require("lspconfig.ui.windows").default_options.border = "rounded"
-- Agrega bordes a Hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
