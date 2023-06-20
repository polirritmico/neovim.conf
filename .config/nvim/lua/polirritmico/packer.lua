-------------------
-- PACKER CONFIG --
-------------------

-- Instalar packer si no está instalado

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git", "clone", "--depth", "1",
		    "https://github.com/wbthomason/packer.nvim",
            install_path
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


-- Autocommand para correr :PackerCompile después de actualizar este archivo
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("Packer", { clear=true }),
	pattern = "*/polirritmico/packer.lua",
	command = "source <afile> | PackerCompile"
})

-- Packer en ventana emergente
--packer.init {
--	compile_path = require("packer.util").join_paths(vim.fn.stdpath("data"),
--	"site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua"),
--	display = {
--		open_fn = function()
--			return require("packer.util").float { border = "rounded" }
--		end,
--	},
--}

--- Carga de plugins ---------------------------------------------------------

return require('packer').startup({function(use)
    -- Packer se maneja a sí mismo
    use({"wbthomason/packer.nvim"})

    -- Telescope ../../after/plugin/telescope.lua
    use({
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    })

    -- LSP ../../after/plugin/lsp.lua
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {
                "williamboman/mason.nvim",
                run = function() pcall(vim.cmd, "MasonUpdate") end,
            },
            {"williamboman/mason-lspconfig.nvim"}, -- Optional
            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"L3MON4D3/LuaSnip"},
        }
    })

    -- Markdown ../../after/plugin/markdown.lua
    use({"preservim/vim-markdown"})

    -- Snippets ../../after/plugin/ultisnips.lua
    --use({"SirVer/ultisnips"}, {"honza/vim-snippets", after = "ultisnips"})
    --use({
    --    "thomasfaingnaert/vim-lsp-ultisnips",
    --    requires = {
    --        "SirVer/ultisnips",
    --        "prabirshrestha/async.vim",
    --        "prabirshrestha/vim-lsp",
    --        "thomasfaingnaert/vim-lsp-snippets",
    --    }
    --})

    -- Automatizar tablas ../../after/plugin/vim-table-mode.lua
    use({"dhruvasagar/vim-table-mode"})

    -- Pares de paréntesis y llaves ../../after/plugin/auto-pairs.lua
    use({"jiangmiao/auto-pairs"})

    -- Colores código ../../after/plugin/treesitter.lua
    use({"nvim-treesitter/nvim-treesitter"}, {run = ":TSUpdate"})

    -- Tema GUI ../../after/plugin/vim-monokai-tasty.lua
    use({"patstockwell/vim-monokai-tasty"})

    -- Barra de estado ../../after/plugin/vim-airline.lua
    use({"vim-airline/vim-airline"})

    -- Líneas o márgenes verticales de indentación
    use({"https://github.com/lukas-reineke/indent-blankline.nvim"})

    -- Modo sin distracciones ../../after/plugin/zen-mode.lua
    use({"folke/zen-mode.nvim"})

    -- Navegar entre archivos abiertos ../../after/plugin/harpoon.lua
    use({"theprimeagen/harpoon"})

    -- Navegar undo tree ../../after/plugin/undotree.lua
    use({"mbbill/undotree"})

    -- GIT
    -- Pantalla de commits
    use({"rhysd/committia.vim"})
    -- Fugitive ../../after/plugin/fugitive.lua
    --use({"tpope/vim-fugitive"})

    -- Comentarios ../../after/plugin/vim-commentary.lua
    use({"tpope/vim-commentary"})

    -- Info de treesitter
    use({"nvim-treesitter/playground"})


    ---------------------------------------------------------------------------


    -- Aplicar automáticamente la configuración después de clonar packer.nvim
    if packer_bootstrap then
        require("packer").sync()
    end
  end,

  -- Ventanta flotante para packer
  config = {
      display = {
          open_fn = function()
              return require("packer.util").float({border = "rounded"})
          end
      }
  }
})
