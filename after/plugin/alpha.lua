-- Alpha-nvim
if not Check_loaded_plugin("alpha-nvim") then return end

require("alpha").setup(require("polirritmico.extras.alpha-theme").config)
