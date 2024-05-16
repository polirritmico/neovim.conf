local api = vim.api

---Functions that create autocommands helpers into the `UserCustomAutocmds` group
---@class UtilsAutoCmds
---@field group_id integer
local UtilsAutoCmds = {
  group_id = api.nvim_create_augroup("UserCustomAutocmds", { clear = true }),
}

---Create an autocmd to launch a file browser plugin when opening dirs.
---@param plugin_name string
---@param plugin_open fun(path: string) Function to open the file browser
function UtilsAutoCmds.attach_file_browser(plugin_name, plugin_open)
  local previous_buffer_name
  api.nvim_create_autocmd("BufEnter", {
    group = UtilsAutoCmds.group_id,
    pattern = "*",
    callback = function()
      vim.schedule(function()
        local buffer_name = api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(buffer_name) == 0 then
          _, previous_buffer_name = pcall(vim.fn.expand, "#:p:h")
          return
        end

        -- Avoid reopening when exiting without selecting a file
        if previous_buffer_name == buffer_name then
          previous_buffer_name = nil
          return
        else
          previous_buffer_name = buffer_name
        end

        -- Ensure no buffers remain with the directory name
        api.nvim_buf_set_option(0, "bufhidden", "wipe")
        plugin_open(vim.fn.expand("%:p:h"))
      end)
    end,
    desc = string.format("[%s] replacement for netrw", plugin_name),
  })
end

---Resize splits and distributions when the neovim's terminal got resized
function UtilsAutoCmds.autoresize_windows()
  vim.api.nvim_create_autocmd("VimResized", {
    group = UtilsAutoCmds.group_id,
    callback = function() vim.cmd.tabdo("wincmd =") end,
    desc = "Resize splits after the neovim's terminal got resized",
  })
end

---Highlight the yanked/copied text. Uses the event `TextYankPost` and the
---group name `User/TextYankHl`.
---@param on_yank_opts? table Options for the on_yank function. Check `:h on_yank for help`.
function UtilsAutoCmds.highlight_yanked_text(on_yank_opts)
  api.nvim_create_autocmd("TextYankPost", {
    group = UtilsAutoCmds.group_id,
    desc = "Highlight yanked text",
    callback = function() vim.highlight.on_yank(on_yank_opts) end,
  })
end

---Create autocmds at "LazyLoad" events.
---The LazyLoad events are triggered by Lazy after loading a plugin, with the name of
---the loaded plugin in the `data` field of the event.
---This function checks if the plugin is already loaded and execute the passed
---function. If not, then it sets an autocmd that waits for the event to
---execute the passed function.
---@param plugin_name string Plugin name waiting to be loaded
---@param fn fun(plugin_name:string) Function to execute after the plugin is loaded
function UtilsAutoCmds.on_load(plugin_name, fn)
  local lazy_cfg = require("lazy.core.config").plugins
  if lazy_cfg[plugin_name] and lazy_cfg[plugin_name]._.loaded then
    fn(plugin_name)
  else
    api.nvim_create_autocmd("User", {
      group = UtilsAutoCmds.group_id,
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

---Sets an autocmd that evaluate the shebang of `sh` files and set the filetype
---to `bash` if matches.
function UtilsAutoCmds.set_bash_ft_from_shebang()
  api.nvim_create_autocmd({ "Filetype" }, {
    desc = "For `*.sh` files set the filetype based on the shebang header line.",
    group = UtilsAutoCmds.group_id,
    pattern = { "sh" },
    callback = function()
      local line = vim.fn.getline(1)
      local pattern1, pattern2 = "^#!.*/bin/env%s+bash", "^#!.*/bin/bash"
      if string.match(line, pattern1) or string.match(line, pattern2) then
        api.nvim_set_option_value("filetype", "bash", { buf = 0 })
      end
    end,
  })
end

---This function automatically creates a custom mapping defined by the provided
---`keymap` when the specified `filetype` is detected. When pressed the mapping,
---it run the passed external command (`ext_cmd`).
---@param filetype string Filetype extension where the mapping is created
---@param keymap string Mapping that is going to trigger the command
---@param ext_cmd string Command to run the file. It will probably start with "`!`".
function UtilsAutoCmds.set_runner(filetype, keymap, ext_cmd)
  local cmd = "noremap " .. keymap .. " <Cmd>" .. ext_cmd .. "<CR>"
  api.nvim_create_autocmd({ "FileType" }, {
    group = UtilsAutoCmds.group_id,
    command = cmd,
    pattern = filetype,
  })
end

---Autocmd to set terminal options and enter into `insert-mode` when opening a
---terminal buffer.
---@param opts table Options to set through `vim.opt_local.[option_name] = value`
function UtilsAutoCmds.setup_term(opts)
  api.nvim_create_autocmd("TermOpen", {
    group = UtilsAutoCmds.group_id,
    callback = function()
      for option, value in pairs(opts) do
        vim.opt_local[option] = value
      end
      vim.cmd.startinsert()
    end,
  })
end

return UtilsAutoCmds
