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
local mason_update = function() pcall(vim.api.nvim_command, "MasonUpdate") end

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
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim", build = mason_update},
            {"williamboman/mason-lspconfig.nvim"},
            {"WhoIsSethDaniel/mason-tool-installer.nvim"},
            -- Autocompletado
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-nvim-lsp"},
            -- Snippets ../../after/plugin/luasnip.lua
            {"saadparwaiz1/cmp_luasnip"},
            {"L3MON4D3/LuaSnip"}, --dependencies = {"rafamadriz/friendly-snippets"},
            -- Ventana emergente con argumentos de funciones
            {"ray-x/lsp_signature.nvim"},
            -- Conecta herramientas no-LSP con el servidor LSP (black, isort)
            {"jose-elias-alvarez/null-ls.nvim", dependencies = {"nvim-lua/plenary.nvim"}},
        }
    },

    -- Treesitter: Análisis sintáctico ../../after/plugin/treesitter.lua
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

    -- DAP: Debugging ../../after/plugin/nvim-dap.lua
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
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-file-browser.nvim"},
            -- {"debugloop/telescope-undo.nvim"},
        },
    },


    ----------------------
    -- Ayudas de código --
    ----------------------

    -- Fix indentación del cierre de {} en Python
    "Vimjas/vim-python-pep8-indent",

    -- Pares de paréntesis y llaves ../../after/plugin/auto-pairs.lua
    -- "jiangmiao/auto-pairs",
    -- Pares de paréntesis y llaves ../../after/plugin/nvim-autopairs.lua
    {"windwp/nvim-autopairs", event = "InsertEnter", opts = {}},
    -- "windwp/nvim-ts-autotag",

    -- Generar docstrings ../../after/plugin/vim-doge.lua
    {"kkoomen/vim-doge", build = ":call doge#install()"},

    -- Markdown ../../after/plugin/markdown.lua
    "preservim/vim-markdown",

    -- Automatizar tablas ../../after/plugin/vim-table-mode.lua
    "dhruvasagar/vim-table-mode",

    -- Conmutar comentarios ../../after/plugin/comments.lua
    "numToStr/Comment.nvim",

    -- Comentarios TODO ../../after/plugin/todo-comments.lua
    {"folke/todo-comments.nvim", dependencies = {"nvim-lua/plenary.nvim"}},


    ----------------------
    -- Modos especiales --
    ----------------------

    -- GIT: Pantalla de commits mejorada
    "rhysd/committia.vim",

    -- Muestra combinaciones de teclas ../../after/plugin/which-key.lua
    -- {"folke/which-key.nvim", event = "VeryLazy"},

    -- Modo sin distracciones ../../after/plugin/zen-mode.lua
    "folke/zen-mode.nvim",

    -- Navegar undo tree ../../after/plugin/undotree.lua
    -- "mbbill/undotree",


    ------------------
    -- Interfaz GUI --
    ------------------

    -- Tema de colores ../../after/plugin/monokai.lua
    { dev = true, priority = 1000, dir = "$HOME/Informática/Programación/monokai.nvim" },
    -- "folke/tokyonight.nvim",

    -- Pantalla de bienvenida ../../after/plugin/alpha-nvim.lua
    {
        'goolord/alpha-nvim', event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- Barra de estado ../../after/plugin/lualine.lua
    "nvim-lualine/lualine.nvim",

    -- Líneas o márgenes verticales de indentación
    "lukas-reineke/indent-blankline.nvim",

    -- Personalizar regla o columna vertical ../../after/plugin/virt-column.lua
    "lukas-reineke/virt-column.nvim",


    ---------------------------
    -- Desarrollo de plugins --
    ---------------------------

    -- Para obtener info de grupos highlight del análisis sintáctico
    "nvim-treesitter/playground",

}

local opts = {}

require("lazy").setup(plugins, opts)

