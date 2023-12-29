--- Greeter screen

return {
    "goolord/alpha-nvim",
    enabled = true,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    event = "VimEnter",
    opts = function()
        return require(MyUser .. ".plugins.extras.alpha-nvim.alpha-theme").config
    end
}
