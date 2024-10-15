---Functions helpers used to load Neovim configs.
---@class UtilsLoader
local Loaders = {}

---Wrapper function to pretty print variables instead of getting memory addresses.
---@param ... any Variable or variables to pretty print
---@return any -- Return the variables unpacked
function P(...)
  local args = { ... }
  local mapped = {}
  for _, variable in pairs(args) do
    table.insert(mapped, vim.inspect(variable))
  end
  print(unpack(mapped))

  return unpack(args)
end

---@type table Collection of errors detected by `load_config` (if any).
Loaders.catched_errors = {}

---_Helper function to load the passed module._
---
---If the module returns an **error**, then print it and store it in the
---`catched_errors` table.
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

---_Helper function to handle detected `load_config` errors_
---
---If an error is detected it will load the fallback settings and **ask the
---user** to open or not the offending file.
---@return boolean -- `true` if errors are detected. `false` otherwise.
function Loaders.detected_errors()
  if #Loaders.catched_errors == 0 then
    return false
  end
  vim.notify("Loading fallback configs.", vim.log.levels.ERROR)
  require("config.fallback.settings")
  require("config.fallback.mappings")

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
