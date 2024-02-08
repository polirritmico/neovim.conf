---A collection of custom helper functions.
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
---@param ... any Variable or variables to pretty print
---@return any # Return the variables unpacked
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

---Redirects the output of the passed command-line into a new buffer
--- **Usage:** `:Redir <the command>`
function Utils.set_cmd_redirection()
  vim.api.nvim_create_user_command("Redir", function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
    vim.cmd("new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
  end, { nargs = "+", complete = "command" })
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

---@type table Collection of errors detected by `load_config` (if any).
Utils._catched_errors = {}

---_Helper function to load the passed module._
---
---If the module returns an **error**, then print it and use the **fallback
---config module** instead (`user.fallback.<module>`). All errors are stored in
---the `Utils._catched_errors` table.
---
---> This expect a fallback config `<module-name.lua>` in the `fallback` folder.
---@param module string Name of the config module to load.
function Utils.load_config(module)
  local ok, err = pcall(require, MyUser .. "." .. module)
  if not ok then
    table.insert(Utils._catched_errors, module)
    local fallback_cfg = MyUser .. ".fallback." .. module
    print("- Error loading the module '" .. module .. "':\n " .. err)
    print("  Loading fallback config file: '" .. fallback_cfg .. "'\n")
    require(fallback_cfg)
  end
end

---Helper function to open config files when errors are detected by
---`load_config`.
---If an error is detected it will **ask the user** to open the offending file.
---If `y` is pressed, it would open each error file in its own buffer.
---@return boolean # `true` if errors are detected. `false` otherwise.
function Utils.detected_errors()
  if #Utils._catched_errors == 0 then
    return false
  end
  if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
    print(" ")
    print("Opening files...")
    for _, module in pairs(Utils._catched_errors) do
      vim.cmd("edit " .. MyConfigPath .. module .. ".lua")
    end
  end
  return true
end

--  NOTE: To create the compiled dict from dic and aff files use:
--  `:mkspell output input`. e.g. For `es_CL.aff` and `es_CL.dic` files, the
--  command should be: `:mkspell es es_CL` (in config/spell dir).

---Enables spell checkers for the specified language.
---@param lang string Language ISO-like string. _E.g. es_CL, es, en, etc._
function Utils.dict_on(lang)
  if vim.api.nvim_get_option("spelllang") ~= lang then
    vim.opt.spelllang = lang
  end
  vim.opt.spell = true
end

---Disable spell checkers and unset the `spelllang` variable.
function Utils.dict_off()
  vim.opt.spelllang = ""
  vim.opt.spell = false
end

---This function enables the **TwoColumns** mode, which splits the current
---buffer into two synced column-like windows, resembling newspaper articles.
---- **Usage**: `:TwoColumns`. To end just close one of the windows.
function Utils.set_two_columns_mode()
  vim.cmd([[
    command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
      \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
  ]])
end

---Give execution permissions to the current buffer if its filetype is in the list
---@param valid_filetypes table[string] Table of accepted filetypes
function Utils.chmod_exe(valid_filetypes)
  for _, ft in pairs(valid_filetypes) do
    if ft == vim.bo.filetype then
      vim.cmd([[!chmod +x %]])
      return
    end
  end
  vim.notify(
    "The current buffer does not have a valid filetype: "
      .. vim.inspect(valid_filetypes)
  )
end

---Show/Hide the fold column at the left of the line numbers.
function Utils.toggle_fold_column()
  if vim.api.nvim_win_get_option(0, "foldcolumn") == "0" then
    vim.opt.foldcolumn = "auto:3"
  else
    vim.opt.foldcolumn = "0"
  end
end

---Sets up an autocmd to create a custom mapping for the passed filetype.
---
---This function automatically creates a custom mapping defined by the provided
---`keymap` when the specified `filetype` is detected. When pressed the mapping,
---it run the passed external command (`ext_cmd`) over the current buffer.
---@param filetype string Filetype extension
---@param keymap string Mapping that is going to trigger the command
---@param ext_cmd string Command to run the file. Should begin with "`!`" and end with "` %`".
function Utils.set_autocmd_runner(filetype, keymap, ext_cmd)
  local cmd = "noremap " .. keymap .. " <Cmd>" .. ext_cmd .. "<CR>"
  vim.api.nvim_create_autocmd({ "FileType" }, { pattern = filetype, command = cmd })
end

---Sets an autocmd that evaluate the shebang of `sh` files and set the filetype
---to `bash` if matches.
function Utils.set_bash_ft_from_shebang()
  local augroup = "ShebangFtDetection"
  vim.api.nvim_create_augroup(augroup, { clear = false })
  vim.api.nvim_create_autocmd({ "Filetype" }, {
    desc = "For `*.sh` files set the filetype based on the shebang header line.",
    group = augroup,
    pattern = { "sh" },
    callback = function()
      local line = vim.fn.getline(1)
      local pattern1, pattern2 = "^#!.*/bin/env%s+bash", "^#!.*/bin/bash"
      if string.match(line, pattern1) or string.match(line, pattern2) then
        vim.api.nvim_set_option_value("filetype", "bash", { buf = 0 })
      end
    end,
  })
end

return Utils
