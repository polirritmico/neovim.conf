-------------------
-- PACKER CONFIG --
-------------------

-- Instalar packer si no está instalado
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git", "clone", "--depth", "1",
		"https://github.com/wbthomason/packer.nvim",
		install_path
	})
	vim.api.nvim_command("packadd packer.nvim")
end

-- Autocommand para correr :PackerCompile después de actualizar este archivo
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("Packer", { clear=true }),
	pattern = "*/polirritmico/packer.lua",
	command = "source <afile> | PackerCompile"
})

-- Usar una llamada protegida para evitar errores en la primer ejecución
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Packer en ventana emergente
packer.init {
	compile_path = require("packer.util").join_paths(vim.fn.stdpath("data"),
	"site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua"),
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}


--- Carga de plugins ---------------------------------------------------------

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
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
  -- try https://github.com/quangnguyen30192/cmp-nvim-ultisnips
  --use({"SirVer/ultisnips"}, {"honza/vim-snippets", after = "ultisnips"})

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

end)
