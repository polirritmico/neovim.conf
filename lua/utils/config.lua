---Functions helpers used to configure Nvim.
---@class UtilsConfig
local Config = {}

---@type table Collection of errors detected by `load_config` (if any).
local catched_errors = {}

---_Helper function to load the passed module._
---
---If the module returns an **error**, then print it and use the **fallback
---config module** instead (`config.fallback.<module>`). All errors are stored in
---the `_catched_errors` table.
---
---> This expect a fallback config `<module-name.lua>` in the `fallback` folder.
---@param module string Name of the config module to load.
---@return any call_return Return of the require module call (if any).
function Config.load_config(module)
  local ok, call_return = pcall(require, "config." .. module)
  if not ok then
    table.insert(catched_errors, module)
    local fallback_cfg = "config.fallback." .. module
    print("- Error loading the module '" .. module .. "':\n " .. call_return)
    print("  Loading fallback config file: '" .. fallback_cfg .. "'\n")
    require(fallback_cfg)
  end
  return call_return
end

---Helper function to open config files when errors are detected by
---`load_config`.
---If an error is detected it will **ask the user** to open the offending file.
---If `y` is pressed, it would open each error file in its own buffer.
---@return boolean # `true` if errors are detected. `false` otherwise.
function Config.detected_errors()
  if #catched_errors == 0 then
    return false
  end
  if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
    print(" ")
    print("Opening files...")
    for _, module in pairs(catched_errors) do
      vim.cmd("edit " .. MyConfigPath .. module .. ".lua")
    end
  end
  return true
end

---A wrapper of `vim.keymap.set` function.
---@param mode string|table Mode short-name
---@param key string Left-hand side of the mapping, the keys to be pressed.
---@param command string|function Right-hand side of the mapping, could be a Lua function.
---@param description? string Optional human-readable description of the mapping, default to nil.
---@param verbose? boolean Optional set to true to disable the silent-mode. Default to false.
function Config.set_keymap(mode, key, command, description, verbose)
  local silent = verbose == nil or not verbose
  if description == nil or description == "" then
    vim.keymap.set(mode, key, command, { silent = silent })
  else
    vim.keymap.set(mode, key, command, { silent = silent, desc = description })
  end
end

---This function check if the current system time is between a time range
---@param start_time integer Start time of the range in HHMM format (inclusive)
---@param end_time integer End time of the range in HHMM format (exclusive)
---@return boolean
function Config.in_hours_range(start_time, end_time)
  local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", { output = true })
  local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))

  return system_time >= start_time and system_time < end_time
end

return Config
