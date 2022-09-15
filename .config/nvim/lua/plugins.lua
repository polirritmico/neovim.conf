-------------------
-- PACKER CONFIG --
-------------------

-- Wrapper
local function get(plugin_name)
    return string.format("require('%s')", plugin_name)
end

-- Carga de plugins
return require("packer").startup(function(use)
    -- Packer
    use({"https://github.com/wbthomason/packer.nvim",})

    -------------------
    -- Visualización --
    -------------------
 
    -- Tema
    use({"https://github.com/patstockwell/vim-monokai-tasty",})

    -- Ajuste a la barra de estado
    use({"https://github.com/vim-airline/vim-airline",
        config = get("plugins-config/vim-airline")})

    -- Resaltado de sintaxis
    use({"https://github.com/nvim-treesitter/nvim-treesitter",
        config = get("plugins-config/nvim-treesitter"),
        run = ":TSUpdate"
    })

    -- LaTeX
    use({"https://github.com/lervag/vimtex",
        config = get("plugins-config/latex")})

    -- Markdown
    use({"https://github.com/preservim/vim-markdown",
        config = get("plugins-config/markdown")})


    -------------------
    -- Funcionalidad --
    -------------------

    -- Pares de paréntesis, comillas, llaves, etc.
    use({"https://github.com/jiangmiao/auto-pairs",
        config = get("plugins-config/auto-pairs")})


    -- Para automatizar tablas
    use({"https://github.com/dhruvasagar/vim-table-mode",
        config = get("plugins-config/vim-table-mode")})

    -- Comentarios
    use({"https://github.com/tpope/vim-commentary",
        config = get("plugins-config/vim-commentary")})


    -------------------------
    -- Ayudantes de código --
    -------------------------

    -- YouCompleteMe (autocompletado)
    use({config = get("plugins-config/YouCompleteMe"),
        "https://github.com/ycm-core/YouCompleteMe"})

    -- Snippets engine
    use({config = get("plugins-config/ultisnips"),
        "https://github.com/SirVer/ultisnips",
        "https://github.com/honza/vim-snippets"
    })

    -- Debugger
    use({config = get("plugins-config/nvim-dap"),
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/rcarriga/nvim-dap-ui",
        "https://github.com/mfussenegger/nvim-dap-python"
    })


end)

