-------------------
-- PACKER CONFIG --
-------------------

-- Instalar Packer si no está instalado
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
    })
    vim.api.nvim_command("packadd packer.nvim")
end

-- Autocommand para correr :PackerCompile después de actualizar este archivo
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("Packer", { clear=true }),
    pattern = "*/plugins/init.lua",
    command = "source <afile> | PackerCompile",
})

-- Usar una llamada protegida para evitar errores en la primera ejecución
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Que Packer utilice una ventana emergente
packer.init {
	compile_path = require('packer.util').join_paths(vim.fn.stdpath('data'),
        'site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua'),
	display = {
		open_fn = function()
			return require('packer.util').float { border = 'rounded' }
		end,
	},
}


--- Carga de plugins ----------------------------------------------------------
return require("packer").startup(function(use)
    -- Packer
    use({"https://github.com/wbthomason/packer.nvim"})

    -------------------
    -- Visualización --
    -------------------
 
    -- Tema
    -- Se necesita cambiar el color de danger porque con treesitter no cambia
    -- el color del fg a blanco:
    -- $XDG_DATA_HOME/nvim/site/pack/packer/start/vim-monokai-tasty/colors
    --      let s:danger = { 'cterm': 197, 'gui': '#ff005f' }
    --      let s:danger = { 'cterm': 197, 'gui': '#a0000f' }
    use({"https://github.com/patstockwell/vim-monokai-tasty",
        run = "sed -i \"s/let s:danger = { 'cterm': 197, 'gui': '#ff005f' }/let s:danger = { 'cterm': 197, 'gui': '#a0000f' }/\" $XDG_DATA_HOME/nvim/site/pack/packer/start/vim-monokai-tasty/colors/vim-monokai-tasty.vim"
    })

    -- Ajuste a la barra de estado
    use({"https://github.com/vim-airline/vim-airline",
        config = function()
            require("plugins.vim-airline")
        end,
    })

    -- LaTeX
    use({"https://github.com/lervag/vimtex",
        config = function()
            require("plugins.latex")
        end,
    })

    -- Markdown
    use({"https://github.com/preservim/vim-markdown",
        config = function()
            require("plugins.markdown")
        end,
    })

    use({"https://github.com/iamcco/markdown-preview.nvim",
        config = function() require("plugins.markdown") end,
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })

    -- QML
    use({"https://github.com/peterhoeg/vim-qml"})


    -------------------
    -- Funcionalidad --
    -------------------

    -- Pares de paréntesis, comillas, llaves, etc.
    use({"https://github.com/jiangmiao/auto-pairs"})

    -- Para automatizar tablas
    use({"https://github.com/dhruvasagar/vim-table-mode",
        config = function()
            require("plugins.vim-table-mode")
        end,
    })

    -- Comentarios
    use({"https://github.com/tpope/vim-commentary",
        config = function()
            require("plugins.vim-commentary")
        end,
    })

    -- Escritura sin distracciones
    use({"https://github.com/junegunn/goyo.vim"})

    -- Telescope (Fuzzy finder)
    use({"https://github.com/nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        config = function()
            require("plugins.telescope")
        end,
        requires = {
            {"https://github.com/nvim-lua/plenary.nvim"},
            {"https://github.com/BurntSushi/ripgrep"}
        },
    })
    -- Requires system package <sys-aps/ripgrep>
    use({'nvim-telescope/telescope-fzf-native.nvim',
        requires = {"nvim-telescope/telescope.nvim"},
        run = "make"
    })

    -------------------------
    -- Ayudantes de código --
    -------------------------

    -- Resaltado de sintaxis
    use({
        "https://github.com/nvim-treesitter/nvim-treesitter",
        --event = "CursorHold",
        run = ":TSUpdate",
        config = function ()
            require("plugins.nvim-treesitter")
        end,
    })

    -- LSP (Language Service Provider)
    use({"https://github.com/neovim/nvim-lspconfig",
        config = function()
            require("plugins.lsp")
        end,
    })

    -- YouCompleteMe (autocompletado)
    -- Si da problemas recompilar:
    --   $ cd $XDG_DATA_HOME/nvim/site/pack/packer/start/YouCompleteMe/
    --   $ python3 install.py
    -- Info en https://github.com/ycm-core/YouCompleteMe#linux-64-bit
    use({"https://github.com/ycm-core/YouCompleteMe",
        config = function()
            require("plugins.YouCompleteMe")
        end,
    })

    -- Snippets engine
    use({{"https://github.com/SirVer/ultisnips",
        config = function()
            require("plugins.ultisnips")
        end,},
        {"https://github.com/honza/vim-snippets", after = "ultisnips"},
    })

    -- Debugger
    use({{"https://github.com/mfussenegger/nvim-dap",
        config = function()
            require("plugins.nvim-dap")
        end,
        },
        {"https://github.com/rcarriga/nvim-dap-ui"},
        {"https://github.com/mfussenegger/nvim-dap-python"},
    })


    ------------------
    -- Mis Pluggins --
    ------------------
     
    -- Transcribe.nvim
    --use({"/home/eduardo/Informática/Programación/transcribe.nvim"})



end)

