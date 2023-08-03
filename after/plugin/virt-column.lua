-- Auto-pairs
local plugin_name = "virt-column.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

require("virt-column").setup({ char = "┊" }) -- Custom char
