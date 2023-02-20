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

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use({"https://github.com/wbthomason/packer.nvim"})

    use({"nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = {{'nvim-lua/plenary.nvim'}}
    })

    use({"https://github.com/patstockwell/vim-monokai-tasty",
        config = function()
            vim.g.vim_monokai_tasty_italic = 1
        end
    })

    use("https://github.com/nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})
    --use("https://github.com/nvim-treesitter/playground")
    use("https://github.com/ThePrimeagen/harpoon")

end)
