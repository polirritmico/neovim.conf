---Functions that create autocommands helpers
---@class UtilsAutoCmds
local UtilsAutoCmds = {}

---Sets up an autocmd to create a custom mapping for the passed filetype.
---This function automatically creates a custom mapping defined by the provided
---`keymap` when the specified `filetype` is detected. When pressed the mapping,
---it run the passed external command (`ext_cmd`) over the current buffer.
---@param filetype string Filetype extension
---@param keymap string Mapping that is going to trigger the command
---@param ext_cmd string Command to run the file. Should begin with "`!`" and end with "` %`".
function UtilsAutoCmds.set_runner(filetype, keymap, ext_cmd)
  local cmd = "noremap " .. keymap .. " <Cmd>" .. ext_cmd .. "<CR>"
  vim.api.nvim_create_autocmd({ "FileType" }, {
    command = cmd,
    group = vim.api.nvim_create_augroup("UserAutocmd_" .. filetype, {}),
    pattern = filetype,
  })
end

---Sets an autocmd that evaluate the shebang of `sh` files and set the filetype
---to `bash` if matches.
function UtilsAutoCmds.set_bash_ft_from_shebang()
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

---Create autocmds at "LazyLoad" events.
---The LazyLoad events are triggered by Lazy after loading a plugin, with the name of
---the loaded plugin in the `data` field of the event.
---This function checks if the plugin is already loaded and execute the passed
---function. If not, then it sets an autocmd that waits for the event and
---execute the passed function.
---@param plugin_name string Name of the plugin to wait
---@param fn fun(plugin_name:string) Function to execute after the plugin is loaded
function UtilsAutoCmds.on_load(plugin_name, fn)
  local lazy_cfg = require("lazy.core.config").plugins
  if lazy_cfg[plugin_name] and lazy_cfg[plugin_name]._.loaded then
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

return UtilsAutoCmds
