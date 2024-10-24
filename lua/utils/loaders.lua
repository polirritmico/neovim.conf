---Helper functions used to load Neovim config modules.
---_(sets the global print wrapper `P`)_
---@class UtilsLoader
local Loaders = {}

---Global helper function to pretty print variables.
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
  if not string.find(module, "lazy") then
    local ok, call_return = pcall(require, module)
    if not ok then
      print("- Error loading the module '" .. module .. "':\n " .. call_return)
      table.insert(Loaders.catched_errors, module)
    end
    return call_return
  end

  -- Set a temporal wrapper for vim.notify, used internally by lazy.nvim, to
  -- capture errors notifications raised by plugin config specs with problems.
  local original_notify = vim.notify
  local notify_wrapper = function(msg, level, opts)
    local pattern = "unexpected symbol near"
    if string.find(msg, pattern) then
      local path = msg:match("^.*\n(.-):%d+:")
      if path ~= "" then
        table.insert(Loaders.catched_errors, path)
      end
    end
    return original_notify("Lazy: " .. msg, level, opts)
  end
  vim.notify = notify_wrapper

  -- Load the lazy config module and then restore vim.notify
  require(module)
  vim.notify = original_notify
end

---_Helper function to handle detected `load_config` errors_
---
---If an error is detected it will load the fallback settings and **ask the
---user** to open or not the offending file.
---@param fallbacks? boolean `true` to load fallback settings if errors are found.
---@return boolean -- Returns `false` if errors are detected. `false` otherwise.
function Loaders.check_errors(fallbacks)
  if #Loaders.catched_errors == 0 then
    return true
  end

  local function get_path_from_error(str)
    if str:sub(1, 1) == "/" then
      return str
    end

    return string.format("%s/lua/%s.lua", NeovimPath, str:gsub("%.", "/"))
  end

  if fallbacks then
    vim.notify("Loading fallback configs.", vim.log.levels.ERROR)
    require("config.fallback.settings")
    require("config.fallback.mappings")
  end

  local msg = string.format("%s\nDetected errors:\n", string.rep("-", 80))
  vim.notify(msg .. vim.inspect(Loaders.catched_errors), vim.log.levels.ERROR)

  if vim.fn.input("Attempt to open offending files for editing? (y/n): ") == "y" then
    print(" ")
    print("Opening files...")
    for _, error in pairs(Loaders.catched_errors) do
      local path = get_path_from_error(error)

      if vim.fn.findfile(path) ~= "" then
        vim.cmd("edit " .. path)
      end
    end
  end
  return false
end

return Loaders
