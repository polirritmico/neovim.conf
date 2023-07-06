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

    ---------------------------
    -- Funcionalidad central --
    ---------------------------

    -- LSP: Language Server Protocol ../../after/plugin/lsp.lua
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = 'v2.x',
        dependencies = {
        -- LSP Support
            {"neovim/nvim-lspconfig"},
            {
                "williamboman/mason.nvim",
                build = function() pcall(vim.cmd, "MasonUpdate") end,
            },
            {"williamboman/mason-lspconfig.nvim"}, -- Optional
            -- Autocompletado
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-nvim-lsp"},
            -- Snippets ../../after/plugin/luasnip.lua
            {
                "L3MON4D3/LuaSnip",
                -- Community snippet collection:
                dependencies = {"rafamadriz/friendly-snippets"},
            },
            {"saadparwaiz1/cmp_luasnip"},
            -- Ventana emergente con argumentos de funciones
            {"ray-x/lsp_signature.nvim"},
            { -- Conecta herramientas no-LSP con el servidor LSP (black, isort)
                "jose-elias-alvarez/null-ls.nvim",
                dependencies = {{"nvim-lua/plenary.nvim"}}
            },
    }},

    -- Treesitter: Análisis sintáctico ../../after/plugin/treesitter.lua
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- DAP: Debugin ../../after/plugin/nvim-dap.lua
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {"rcarriga/nvim-dap-ui"}, {"mfussenegger/nvim-dap-python"}
        }
    },

    -- Navegar entre archivos abiertos ../../after/plugin/harpoon.lua
    "theprimeagen/harpoon",

    -- Telescope: Búsquedas con fzf ../../after/plugin/telescope.lua
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.2',
        dependencies = {{"nvim-lua/plenary.nvim"}}
    },


    ----------------------
    -- Ayudas de código --
    ----------------------

    -- Fix indentación del cierre de {}
    "Vimjas/vim-python-pep8-indent",

    -- Pares de paréntesis y llaves ../../after/plugin/auto-pairs.lua
    "jiangmiao/auto-pairs",

    -- Generar docstrings ../../after/plugin/vim-doge.lua
    {"kkoomen/vim-doge", build = ":call doge#install()"},

    -- Markdown ../../after/plugin/markdown.lua
    "preservim/vim-markdown",

    -- Automatizar tablas ../../after/plugin/vim-table-mode.lua
    "dhruvasagar/vim-table-mode",

    -- Comentarios ../../after/plugin/vim-commentary.lua
    --"tpope/vim-commentary",
    -- Comentarios ../../after/plugin/comments.lua
    "numToStr/Comment.nvim",

    -- Comentarios TODO ../../after/plugin/todo-comments.lua
    {
        "folke/todo-comments.nvim",
        dependencies = {"nvim-lua/plenary.nvim"}
    },


    ----------------------
    -- Modos especiales --
    ----------------------

    -- GIT Pantalla de commits
    "rhysd/committia.vim",

    -- Modo sin distracciones ../../after/plugin/zen-mode.lua
    "folke/zen-mode.nvim",

    -- Para obtener info de grupos highlight del análisis sintáctico
    --"nvim-treesitter/playground",

    -- Navegar undo tree ../../after/plugin/undotree.lua
    --"mbbill/undotree",

    -- Nvim-tree: Explorador de archivos ../..after/plugin/nvim-tree.lua
    --{
    --    "nvim-tree/nvim-tree.lua", version = "*",
    --    dependencies = { "nvim-tree/nvim-web-devicons" },
    --},


    ------------------
    -- Interfaz GUI --
    ------------------

    -- Tema de colores ../../after/plugin/vim-monokai-tasty.lua
    {
        dev = true, priority = 1000,
        dir = "$HOME/Informática/Programación/vim-monokai-tasty"
    },

    -- Pantalla de bienvenida ../../after/plugin/alpha-nvim.lua
    {
        'goolord/alpha-nvim', event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- Barra de estado ../../after/plugin/status-bar.lua
    "vim-airline/vim-airline",

    -- Líneas o márgenes verticales de indentación
    "lukas-reineke/indent-blankline.nvim",

    -- Personalizar regla o columna vertical ../../after/plugin/virt-column.lua
    "lukas-reineke/virt-column.nvim",
}

local opts = {}

require("lazy").setup(plugins, opts)

