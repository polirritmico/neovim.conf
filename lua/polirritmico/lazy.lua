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

-- Config
local opts = {
    change_detection = {
        enabled = true,
        notify = true,
    },
    dev = {
        path = MyPluginsPath,
        fallback = false,
    },
    install = {
        colorscheme = { "monokai-nightasty" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zip",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded"
    },
}

local specs_folders = {
    {import = MyUser .. ".plugins.core"},
    {import = MyUser .. ".plugins.develop"},
    {import = MyUser .. ".plugins.helpers"},
    {import = MyUser .. ".plugins.misc"},
    {import = MyUser .. ".plugins.ui"},
}
require("lazy").setup(specs_folders, opts)
