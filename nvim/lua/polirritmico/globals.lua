-- Globals

-- Paths
MyConfigPath = " ~/.config/nvim/lua/polirritmico/"
MyPluginConfigPath = " ~/.config/nvim/after/plugin/"

-- Helper functions
-- To print the content of a table instead of the table memory address
P = function(v)
    print(vim.inspect(v))
    return v
end

-- This will check if the plugin is loaded. Used in the config files in after
-- to load the config only if the plugin is installed and loaded.
Check_loaded_plugin = function(check_plugin_name)
    local lazy_success, lazy_module = pcall(require, "lazy")
    if not lazy_success then
        return false
    end
    if type(lazy_module.plugins) ~= "function" then
        return false
    end

    local loaded_plugins = lazy_module.plugins()
    for _, plugin in ipairs(loaded_plugins) do
        if check_plugin_name == plugin.name then
            return true
        end
    end
    return false
end
