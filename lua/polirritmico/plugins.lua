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
        {"neovim/nvim-lspconfig"},
        {"williamboman/mason.nvim", build = mason_update},
        {"williamboman/mason-lspconfig.nvim"},
        {"WhoIsSethDaniel/mason-tool-installer.nvim"}, -- debugpy
        -- Autocompletado
        {"hrsh7th/nvim-cmp"},
        {"hrsh7th/cmp-nvim-lsp"},
        -- Snippets ../../after/plugin/luasnip.lua
        {"saadparwaiz1/cmp_luasnip"},
        {"L3MON4D3/LuaSnip"},
        -- Ventana emergente con argumentos de funciones
        {"ray-x/lsp_signature.nvim"},
        -- Conecta herramientas no-LSP con el servidor LSP (black, isort)
        {"jose-elias-alvarez/null-ls.nvim", dependencies = {"nvim-lua/plenary.nvim"}},
    },

    -- Treesitter: Análisis sintáctico ../../after/plugin/treesitter.lua
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    -- Mostrar el contexto del código en la línea superior (func, clases, etc.)
    {"nvim-treesitter/nvim-treesitter-context"},

    -- Telescope: Búsquedas con fzf ../../after/plugin/telescope.lua
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.2',
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-file-browser.nvim"},
            {"crispgm/telescope-heading.nvim"},
            -- {"debugloop/telescope-undo.nvim"},
        },
    },

    -- Guardar sesiones ../../after/plugin/vim-obsession.lua
    {"tpope/vim-obsession"},


    -------------------------
    -- Testing & Debugging --
    -------------------------

    -- DAP: Debugging ../../after/plugin/nvim-dap.lua
    {
        "mfussenegger/nvim-dap",
        tag = "0.6.0",
        dependencies = {
            {"rcarriga/nvim-dap-ui"}, {"mfussenegger/nvim-dap-python"}
        }
    },

    -- Ejecuciones de tests ../../after/plugin/vim-test.lua
    "vim-test/vim-test",


    ----------------------
    -- Ayudas de código --
    ----------------------

    -- Integración git
    -- "tpope/vim-fugitive",

    -- Navegar entre archivos abiertos ../../after/plugin/harpoon.lua
    "theprimeagen/harpoon",

    -- Fix indentación del cierre de {} en Python
    "Vimjas/vim-python-pep8-indent",

    -- Pares de paréntesis y llaves ../../after/plugin/nvim-autopairs.lua
    {"windwp/nvim-autopairs", event = "InsertEnter", opts = {}},
    -- "windwp/nvim-ts-autotag",

    -- Generar docstrings ../../after/plugin/vim-doge.lua
    {"kkoomen/vim-doge", build = ":call doge#install()"},

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

    -- Centrado del buffer y notas ../../after/plugin/no-neck-pain.lua
    {"shortcuts/no-neck-pain.nvim", version = "*"},

    -- Navegar undo tree ../../after/plugin/undotree.lua
    -- "mbbill/undotree",


    ------------------
    -- Interfaz GUI --
    ------------------

    -- Tema de colores ../../after/plugin/monokai-nightasty.lua
    {
        name="monokai-nightasty.nvim", dev = true, priority = 1000,
        dir = "$HOME/Informática/Programación/monokai.nvim"
    },
    -- { "polirritmico/monokai-nightasty.nvim", priority = 1000, lazy = false },

    -- Pantalla de bienvenida ../../after/plugin/alpha-nvim.lua
    {
        'goolord/alpha-nvim', event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- Barra de estado ../../after/plugin/lualine.lua
    "nvim-lualine/lualine.nvim",

    -- Líneas guía de indentación ../../after/plugin/indent-blankline.lua
    "lukas-reineke/indent-blankline.nvim",

    -- Personalizar regla o columna vertical ../../after/plugin/virt-column.lua
    "lukas-reineke/virt-column.nvim",


    ---------------------------
    -- Desarrollo de plugins --
    ---------------------------

    -- Para obtener info de grupos highlight del análisis sintáctico
    "nvim-treesitter/playground",

    -- ../../after/plugin/gitsigns.lua
    -- {"lewis6991/gitsigns.nvim"},
}

local opts = { readme = { enabled = false } }

require("lazy").setup(plugins, opts)
