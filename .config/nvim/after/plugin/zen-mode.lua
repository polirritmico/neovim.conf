-- Zen Mode
local plugin_name = "zen-mode.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

require("zen-mode").setup({
    window = {
        width = 91,
        height = 1,
        --options = {
        --    cursorline = false,
        --},
    },
})
