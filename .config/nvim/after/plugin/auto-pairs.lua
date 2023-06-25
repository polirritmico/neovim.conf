-- Auto-pairs
local plugin_name = "auto-pairs"
if not Check_loaded_plugin(plugin_name) then
    return
end

vim.g.AutoPairsFlyMode = 0 -- Enables/disables Fly mode
