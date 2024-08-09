local api = vim.api

---Functions that create autocommands helpers into the `UserCustomAutocmds` group
---@class UtilsAutoCmds
---@field group_id integer Group `UserCustomAutocmds` id
local Autocmds = {
  group_id = api.nvim_create_augroup("UserUtilsCustomAutocmds", { clear = true }),
}

---Create an autocmd to launch a file browser plugin when opening dirs.
---@param plugin_name string
---@param plugin_open fun(path: string) Function to open the file browser
function Autocmds.attach_file_browser(plugin_name, plugin_open)
  local previous_buffer_name
  api.nvim_create_autocmd("BufEnter", {
    group = Autocmds.group_id,
    desc = string.format("[%s] replacement for Netrw", plugin_name),
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
        api.nvim_set_option_value("bufhidden", "wipe", { buf = 0 })
        plugin_open(vim.fn.expand("%:p:h"))
      end)
    end,
  })
end

---Resize splits and distributions when the neovim's terminal got resized
function Autocmds.autoresize_splits_at_window_resize()
  vim.api.nvim_create_autocmd("VimResized", {
    group = Autocmds.group_id,
    desc = "Resize splits after the neovim's terminal got resized",
    callback = function() vim.cmd.tabdo("wincmd =") end,
  })
end

---Highlight the yanked/copied text. Uses the event `TextYankPost` and the
---group name `Autocmds.group_id` (`UserCustomAutocmds`).
---@param on_yank_opts? table Options for the on_yank function. Check `:h on_yank for help`.
function Autocmds.highlight_yanked_text(on_yank_opts)
  api.nvim_create_autocmd("TextYankPost", {
    group = Autocmds.group_id,
    desc = "Highlight yanked text",
    callback = function() vim.highlight.on_yank(on_yank_opts) end,
  })
end

---Create autocmds at "LazyLoad" events.
---The LazyLoad events are triggered by Lazy after loading a plugin, with the
---name of the loaded plugin in the `data` field of the event.
---This function checks if the plugin is already loaded and executes the passed
---function. If not, it sets an autocmd that waits for the event raised when the
---plugin is loaded and then executes the passed function.
---@param plugin_name string Plugin name waiting to be loaded
---@param fn fun(plugin_name:string) Function to execute after the plugin is loaded
function Autocmds.on_load(plugin_name, fn)
  local lazy_cfg = require("lazy.core.config").plugins
  if lazy_cfg[plugin_name] and lazy_cfg[plugin_name]._.loaded then
    fn(plugin_name)
  else
    local msg = "Execute the attached function when [%s] is loaded by Lazy"
    api.nvim_create_autocmd("User", {
      group = Autocmds.group_id,
      desc = string.format(msg, plugin_name),
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

---Restore the cursor to its last position when reopening the buffer.
---Copied from the manual. Check `:h restore-cursor`
function Autocmds.save_cursor_position_in_file()
  vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]])
end

---Sets an autocmd that evaluate the shebang of `sh` files and set the filetype
---to `bash` if matches.
function Autocmds.set_bash_ft_from_shebang()
  api.nvim_create_autocmd({ "Filetype" }, {
    group = Autocmds.group_id,
    desc = "Set the filetype based on the shebang header (for .sh files).",
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
function Autocmds.set_runner(filetype, keymap, ext_cmd)
  local cmd = "noremap " .. keymap .. " <Cmd>" .. ext_cmd .. "<CR>"
  api.nvim_create_autocmd({ "FileType" }, {
    group = Autocmds.group_id,
    command = cmd,
    pattern = filetype,
  })
end

---Autocmd to set terminal options and enter into `insert-mode` when opening a
---terminal buffer.
---@param opts table Options to set through `vim.opt_local.[option_name] = value`
function Autocmds.setup_term_opts(opts)
  api.nvim_create_autocmd("TermOpen", {
    group = Autocmds.group_id,
    desc = "Open `terminal-mode` in `insert-mode` and apply options",
    callback = function(ev)
      -- Only apply to user terminals (avoids internal plugins terms like dap)
      if ev.file:match("term://.*/bin/bash") then
        for option, value in pairs(opts) do
          vim.opt_local[option] = value
        end
        vim.cmd.startinsert()
      end
    end,
  })
end

return Autocmds
