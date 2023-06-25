-------------------------
-- LAZY PLUGINS CONFIG --
-------------------------

-- Instalar Lazy si no está instalado
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

--- Carga de plugins ---------------------------------------------------------

local plugins = {
    -- Telescope ../../after/plugin/telescope.lua
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.2',
        dependencies = {{"nvim-lua/plenary.nvim"}}
    },
    "nvim-telescope/telescope-file-browser.nvim",

    -- LSP ../../after/plugin/lsp.lua
    {"VonHeikemen/lsp-zero.nvim",
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        {"neovim/nvim-lspconfig"},
        {
            "williamboman/mason.nvim",
            build = function() pcall(vim.cmd, "MasonUpdate") end,
        },
        {"williamboman/mason-lspconfig.nvim"}, -- Optional
        -- Autocompletion
        {"hrsh7th/nvim-cmp"},
        {"hrsh7th/cmp-nvim-lsp"},
        {"L3MON4D3/LuaSnip"},
    }},

    -- Inject non-LSP tools ../../after/plugin/null-ls.lua
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {{"nvim-lua/plenary.nvim"}}
    },

    -- DAP (debugin) ../../after/plugin/nvim-dap.lua
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",

    -- Markdown ../../after/plugin/markdown.lua
    "preservim/vim-markdown",

    -- Automatizar tablas ../../after/plugin/vim-table-mode.lua
    "dhruvasagar/vim-table-mode",

    -- Pares de paréntesis y llaves ../../after/plugin/auto-pairs.lua
    "jiangmiao/auto-pairs",

    -- Colores código ../../after/plugin/treesitter.lua
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- Tema GUI ../../after/plugin/vim-monokai-tasty.lua
    {dev = true, dir = "$HOME/Informática/Programación/vim-monokai-tasty"},

    -- Barra de estado ../../after/plugin/status-bar.lua
    "vim-airline/vim-airline",

    -- Líneas o márgenes verticales de indentación
    "lukas-reineke/indent-blankline.nvim",

    -- colorcoulmn a línea ../../after/plugin/virt-column.lua
    "lukas-reineke/virt-column.nvim",

    -- Modo sin distracciones ../../after/plugin/zen-mode.lua
    "folke/zen-mode.nvim",

    -- Navegar entre archivos abiertos ../../after/plugin/harpoon.lua
    "theprimeagen/harpoon",

    -- Navegar undo tree ../../after/plugin/undotree.lua
    "mbbill/undotree",

    -- GIT Pantalla de commits
    "rhysd/committia.vim",

    -- Comentarios ../../after/plugin/vim-commentary.lua
    "tpope/vim-commentary",

    -- Check highlights and nvim internals
    --"nvim-treesitter/playground",

    -- TODO ../../after/plugin/todo-comments.lua
    {
        "folke/todo-comments.nvim",
        dependencies = {"nvim-lua/plenary.nvim"}
    },
}

local opts = {}

require("lazy").setup(plugins, opts)

