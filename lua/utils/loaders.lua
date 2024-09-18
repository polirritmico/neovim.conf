---Functions helpers used to load Neovim configs.
---@class UtilsLoader
local Loaders = {}

---@type table Collection of errors detected by `load_config` (if any).
Loaders.catched_errors = {}

---_Helper function to load the passed module._
---
---If the module returns an **error**, then print it and use the **fallback
---config module** instead (`config.fallback.<module>`). All errors are stored in
---the `_catched_errors` table.
---
---> This expect a fallback config `<module-name.lua>` in the `fallback` folder.
---@param module string Name of the module to load.
---@return any call_return Return of the require module call (if any).
function Loaders.load_config(module)
  local ok, call_return = pcall(require, module)
  if not ok then
    print("- Error loading the module '" .. module .. "':\n " .. call_return)
    table.insert(Loaders.catched_errors, module)
  end
  return call_return
end

---Load config fallback modules
function Loaders.load_fallbacks()
  vim.notify("Error detected. Using fallback config", vim.log.levels.ERROR)
  require("config.fallback.settings")
  require("config.fallback.mappings")
end

---Helper function to open config files when errors are detected by
---`load_config`.
---If an error is detected it will **ask the user** to open the offending file.
---If `y` is pressed, it would open each error file in its own buffer.
---@return boolean # `true` if errors are detected. `false` otherwise.
function Loaders.detected_errors()
  if #Loaders.catched_errors == 0 then
    return false
  end
  Loaders.load_fallbacks()
  local msg = string.format("Detected errors:\n%s", vim.inspect(Loaders.catched_errors))
  vim.notify(msg, vim.log.levels.ERROR)
  if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
    print(" ")
    print("Opening files...")
    for _, module in pairs(Loaders.catched_errors) do
      local path = string.format("%s/lua/%s.lua", NeovimPath, module:gsub("%.", "/"))
      if vim.fn.findfile(path) ~= "" then
        vim.cmd("edit " .. path)
      end
    end
  end
  return true
end

return Loaders
