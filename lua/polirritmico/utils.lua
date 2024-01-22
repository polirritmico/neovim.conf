---Collection of custom helper functions
---@class Utils
local Utils = {}

---A wrapper of `vim.keymap.set` function.
---@param mode string|table Mode short-name
---@param key string Left-hand side of the mapping, the keys to be pressed.
---@param command string|function Right-hand side of the mapping, could be a Lua function.
---@param description? string Optional human-readable description of the mapping, default to nil.
---@param verbose? boolean Optional set to true to disable the silent-mode. Default to false.
function Utils.set_keymap(mode, key, command, description, verbose)
  local silent = verbose == nil or not verbose
  if description == nil or description == "" then
    vim.keymap.set(mode, key, command, { silent = silent })
  else
    vim.keymap.set(mode, key, command, { silent = silent, desc = description })
  end
end

---Wrapper function to pretty print variables instead of getting memory addresses.
---@vararg any
---@return any
function Utils.custom_print(...)
  local args = { ... }
  local mapped = {}
  if args == nil then
    print("nil")
    return nil
  end
  for _, variable in pairs(args) do
    table.insert(mapped, vim.inspect(variable))
  end
  print(unpack(mapped))

  return unpack(args)
end

---Create autocmds at "LazyLoad" events.
---@param plugin_name string
---@param fn fun(plugin_name:string)
function Utils.on_load(plugin_name, fn)
  local lazy_cfg = require("lazy.core.config")
  if lazy_cfg.plugins[plugin_name] and lazy_cfg.plugins[plugin_name]._.loaded then
    fn(plugin_name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == plugin_name then
          fn(plugin_name)
          return true
        end
      end,
    })
  end
end

---Check if the plugin is specified in the Lazy Plugins configuration and currently enabled
---@param plugin string
---@return boolean
function Utils.lazy_has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---Function used to set a custom text when called by a fold action like zc.
---Should be setted with opt.foldtext = "v:lua.CustomFoldText()"
function Utils.fold_text()
  local first_line = vim.fn.getline(vim.v.foldstart)
  local last_line = vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
  local lines_count = tostring(vim.v.foldend - vim.v.foldstart)
  local space_width = vim.api.nvim_get_option("textwidth")
    - #first_line
    - #last_line
    - #lines_count
    - 10
  return string.format(
    "%s  %s %s (%d L)",
    first_line,
    last_line,
    string.rep(".", space_width),
    lines_count
  )
end

--- Table of errors detected by load_config (if any).
Utils.catched_errors = {}

---Helper function to load the passed module. If the module returns an error,
---then print it and load the fallback config module (user.fallback.file).
---All errors are stored int the `Utils.catched_errors` table.
---(This expect a fallback config named <module-name.lua> in the `fallback`
---folder)
---@param module string Name of the config module to load.
function Utils.load_config(module)
  local ok, err = pcall(require, MyUser .. "." .. module)
  if not ok then
    table.insert(Utils.catched_errors, module)
    local fallback_cfg = MyUser .. ".fallback." .. module
    print("- Error loading the module '" .. module .. "':\n " .. err)
    print("  Loading fallback config file: '" .. fallback_cfg .. "'\n")
    require(fallback_cfg)
  end
end

---Helper function to open config files when errors are detected.
function Utils.detected_errors()
  if #Utils.catched_errors == 0 then
    return false
  end
  if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
    print(" ")
    print("Opening files...")
    for _, module in pairs(Utils.catched_errors) do
      vim.cmd("edit " .. MyConfigPath .. module .. ".lua")
    end
  end
  return true
end

---Enable spanish dictionary and spell checkers
--  NOTE: To create the compiled dict from dic and aff files use:
--  `:mkspell output input`. e.g. For `es_CL.aff` and `es_CL.dic` files, the
--  command should be: `:mkspell es es_CL` (in config/spell dir).
function Utils.es_dict()
  vim.opt.spelllang = { "es" }
  vim.cmd([[set spellfile="~/.config/nvim/spell/es.utf-8"]])
  vim.opt.spell = true
end

return Utils
