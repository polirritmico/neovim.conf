local user = "polirritmico"

-- TODO: Move to util
-- Helper function to load the passed module. If the module returns an error,
-- then print it and load the fallback config module (user.fallback.file).
-- (This expect a fallback config named <module-name.lua> in the fallback folder)
local catched_errors = {}
local function load_config(module)
    local ok, err = pcall(require, user .. "." .. module)
    if not ok then
        table.insert(catched_errors, module)
        local fallback_cfg = user .. ".fallback." .. module
        print("- Error loading the module '" .. module .. "':\n " .. err)
        print("  Loading fallback config file: '" .. fallback_cfg .. "'\n")
        require(fallback_cfg)
    end
end

-- Helper function to open config files when errors are detected.
local function detected_errors(errors)
    if #errors == 0 then
        return false
    end
    if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
        print(" "); print("Opening files...")
        local config_path = vim.fn.stdpath("config") .. "/lua/" .. user
        for _, module in pairs(errors) do
            vim.cmd("edit " .. config_path .. "/" .. module .. ".lua")
        end
    end
    return true
end

-------------------------------------------------------------------------------

-- Load the config modules (globals expected first)
load_config("globals")
--load_config("utils")
-- load_config("disable-builtin")
load_config("settings")
load_config("mappings")

if not detected_errors(catched_errors) then
    require(user .. ".lazy")
end
