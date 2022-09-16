-------------------
-- PACKER CONFIG --
-------------------

-- Autocommand para correr :PackerCompile después de actualizar este archivo
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("Packer", { clear=true }),
    pattern = "packer.lua",
    command = "source <afile> | PackerCompile",
})

-- Carga de plugins
return require("packer").startup(function(use)
    -- Packer
    use("https://github.com/wbthomason/packer.nvim")

    -------------------
    -- Visualización --
    -------------------
 
    -- Tema
    use({"https://github.com/patstockwell/vim-monokai-tasty"})

    -- Ajuste a la barra de estado
    use({"https://github.com/vim-airline/vim-airline",
        config = function()
            require("plugins.vim-airline")
        end,
    })

    -- Resaltado de sintaxis
    use({
        "https://github.com/nvim-treesitter/nvim-treesitter",
        --event = "CursorHold",
        run = ":TSUpdate",
        config = function ()
            require("plugins.nvim-treesitter")
        end,
    })

    -- LaTeX
    use({"https://github.com/lervag/vimtex",
        config = function()
            require("plugins.latex")
        end,
    })

    ---- Markdown
    use({"https://github.com/preservim/vim-markdown",
        config = function()
            require("plugins.markdown")
        end,
    })


    ---------------------
    ---- Funcionalidad --
    ---------------------

    -- Pares de paréntesis, comillas, llaves, etc.
    use({"https://github.com/jiangmiao/auto-pairs",
        config = function()
            require("plugins.auto-pairs")
        end,
    })


    ---- Para automatizar tablas
    use({"https://github.com/dhruvasagar/vim-table-mode",
        config = function()
            require("plugins.vim-table-mode")
        end,
    })

    -- Comentarios
    use({"https://github.com/tpope/vim-commentary"})
    --use({"https://github.com/tpope/vim-commentary",
    --    config = function()
    --        require("plugins.vim-comentary")
    --    end,
    --})


    ---------------------------
    ---- Ayudantes de código --
    ---------------------------

    -- YouCompleteMe (autocompletado)
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
        end,},
        {"https://github.com/rcarriga/nvim-dap-ui", requires = "nvim-dap"},
        {"https://github.com/mfussenegger/nvim-dap-python", requires = "nvim-dap"},
    })

end)

