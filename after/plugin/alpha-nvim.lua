-- Alpha-nvim
local plugin_name = "alpha-nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

-- require("alpha").setup(require("alpha.themes.startify").config)
require("alpha").setup(require("polirritmico.extras.alpha-theme").config)
