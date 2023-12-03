-------------------------
-- LAZY PLUGINS CONFIG --
-------------------------

-- Lazy bootstrap
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

local plugins = {

    ------------------------
    -- Core Functionality --
    ------------------------

    -- LSP: Language Server Protocol ../../after/plugin/lsp.lua
    {
        {"neovim/nvim-lspconfig"},
        {"williamboman/mason.nvim", build = mason_update},
        {"williamboman/mason-lspconfig.nvim"},
        {"WhoIsSethDaniel/mason-tool-installer.nvim"}, -- debugpy
        -- Autocompletion
        {"hrsh7th/nvim-cmp"},
        {"hrsh7th/cmp-nvim-lsp"},
        -- Snippets ../../after/plugin/luasnip.lua
        {"saadparwaiz1/cmp_luasnip"},
        {"L3MON4D3/LuaSnip"},
        -- Floating window with function documentation and args
        {"ray-x/lsp_signature.nvim"},
        -- Connects no-LSP tools with the LSP server (black, isort, etc.)
        {"jose-elias-alvarez/null-ls.nvim", dependencies = "nvim-lua/plenary.nvim"},
    },

    -- Treesitter: Syntactic analysis ../../after/plugin/treesitter.lua
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

    -- Shows code context on the top (func, classes, etc.)
    {"nvim-treesitter/nvim-treesitter-context"},

    -- Telescope: Searches with fzf ../../after/plugin/telescope.lua
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.5',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "crispgm/telescope-heading.nvim",
            -- "debugloop/telescope-undo.nvim",
        },
    },

    -- Save sessions ../../after/plugin/vim-obsession.lua
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

    -- Test manager ../../after/plugin/vim-test.lua
    "polirritmico/nvim-test", -- "klen/nvim-test",
    -- {
    --     "nvim-neotest/neotest",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "antoinemadec/FixCursorHold.nvim",
    --         "nvim-neotest/neotest-python",
    --     }
    -- },


    ------------------
    -- Code helpers --
    ------------------

    -- Navigation through pinned files ../../after/plugin/harpoon.lua
    {"theprimeagen/harpoon"},

    -- Fix close {} indentation for Python
    {"Vimjas/vim-python-pep8-indent"},

    -- Pairs of (), [], {} ../../after/plugin/nvim-autopairs.lua
    {"windwp/nvim-autopairs", event = "InsertEnter", opts = {}},

    -- Docstrings generation ../../after/plugin/vim-doge.lua
    -- {"kkoomen/vim-doge", build = ":call doge#install()"},

    -- Tables automatization ../../after/plugin/vim-table-mode.lua
    {"dhruvasagar/vim-table-mode"},

    -- Toggle comments ../../after/plugin/comments.lua
    {"numToStr/Comment.nvim"},

    -- TODO, FIX, etc. comments highlights ../../after/plugin/todo-comments.lua
    {"folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim"},


    -------------------
    -- Special Modes --
    -------------------

    -- Git: Improved commits screen
    {"rhysd/committia.vim"},

    -- Git: Handle git whitin nvim
    -- {"tpope/vim-fugitive"},

    -- Git: Highlight code changes from last commit ../../after/plugin/gitsigns.lua
    {"lewis6991/gitsigns.nvim"},

    -- Center buffer on screen and add notes ../../after/plugin/no-neck-pain.lua
    {"shortcuts/no-neck-pain.nvim", version = "*"},

    -- Undo tree navegation ../../after/plugin/undotree.lua
    -- {"mbbill/undotree"},


    -------------------
    -- GUI Interface --
    -------------------

    -- The best colorscheme ../../after/plugin/monokai-nightasty.lua
    {
        name = "monokai-nightasty.nvim", priority = 1000,
        dir = "$HOME/Informática/Programación/monokai.nvim"
    },
    -- { "polirritmico/monokai-nightasty.nvim", priority = 1000, lazy = false },

    -- Greeter screen ../../after/plugin/alpha-nvim.lua
    {
        "goolord/alpha-nvim", event = "VimEnter",
        dependencies = {"nvim-tree/nvim-web-devicons"}
    },

    -- Status bar ../../after/plugin/lualine.lua
    {"nvim-lualine/lualine.nvim"},

    -- Indentation guide lines ../../after/plugin/indent-blankline.lua
    {"lukas-reineke/indent-blankline.nvim"},

    -- Custom vertical width column/ruler ../../after/plugin/virt-column.lua
    {"lukas-reineke/virt-column.nvim"},


    ------------------------
    -- Plugin development --
    ------------------------

    -- Get info about syntax highlight
    {"nvim-treesitter/playground"},
}

local opts = { readme = { enabled = false }, ui = { border = "rounded" } }

require("lazy").setup(plugins, opts)
