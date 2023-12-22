--- Greeter screen

return {
    "goolord/alpha-nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    event = "VimEnter",
    opts = function()
        return require(MyUser .. ".extras.alpha-theme").config
    end
}
