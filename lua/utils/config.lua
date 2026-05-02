---Helper functions used to configure Neovim.
---@class UtilsConfig
local Config = {}

---Enable system `bash_aliases` in the nvim command-line.
---
---This also sets the `NVIM` environment variable that could be used by bash
---scripts to detect calls from within a Neovim instance. For example:
---```bash
---[ "$NVIM" ] && echo "in nvim" || echo "in terminal";
---```
function Config.enable_bash_aliases()
  vim.uv.os_setenv("NVIM", "1")
  vim.env.BASH_ENV = NeovimPath .. "/patches/bash_aliases"
end

---Add an autocmd to disable Jedi LSP completion if Rope is available in venv.
function Config.lsp_disable_jedi_completion_if_rope_is_enabled()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil or client.name ~= "pylsp" then
        return
      end

      local h = require("utils.helpers")
      local python = h.local_or_global("python", "/.venv/bin/")
      vim.fn.system({ python, "-c", "import rope" })
      local has_rope = vim.v.shell_error == 0

      local pylsp_plugins = client.config.settings.pylsp["plugins"]
      pylsp_plugins.rope_completion = { enabled = has_rope }
      pylsp_plugins.jedi_completion = { enabled = not has_rope }
    end,
  })
end

---Wrapper to center the screen after vim.lsp.buf.definition (async)
---execution: `gd` -> `gdzz`.
---@return function
function Config.lsp_centered_definition()
  local method = "textDocument/definition"
  local mk_position_params = require("vim.lsp.util").make_position_params
  return function(bufnr)
    vim.lsp.buf_request(bufnr, method, mk_position_params(0, "utf-8"), function()
      vim.lsp.buf.definition()
      vim.api.nvim_feedkeys("zz", "n", true)
    end)
  end
end

---Toggle LSP diagnostic (mainly hide virtual-text messages).
function Config.lsp_toggle_diagnostics()
  return function()
    local state = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not state)
    vim.notify("LSP: Diagnostics " .. (state and "disabled" or "enabled"))
  end
end

---This function check if the current system time is between a time range.
---@param start_time integer Start time of the range in HHMM format (inclusive)
---@param end_time integer End time of the range in HHMM format (exclusive)
---@return boolean
function Config.in_hours_range(start_time, end_time)
  local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", { output = true })
  local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))

  return system_time >= start_time and system_time < end_time
end

---A wrapper of `vim.keymap.set` function.
---@param mode string|table Mode short-name
---@param key string Left-hand side of the mapping, the keys to be pressed.
---@param command string|function Right-hand side of the mapping, could be a Lua function.
---@param description? string Optional human-readable description of the mapping, default to nil.
---@param verbose? boolean Optionally set to `true` to disable the silent-mode.
function Config.set_keymap(mode, key, command, description, verbose)
  if description == nil or description == "" then
    vim.keymap.set(mode, key, command, { silent = not verbose })
  else
    vim.keymap.set(mode, key, command, { silent = not verbose, desc = description })
  end
end

---A wrapper of `vim.keymap.set` function for the current buffer.
---@param mode string|table Mode short-name
---@param key string Left-hand side of the mapping, the keys to be pressed.
---@param command string|function Right-hand side of the mapping, could be a Lua function.
---@param desc? string Optional human-readable description of the mapping, default to nil.
function Config.set_ft_keymap(mode, key, command, desc)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set(mode, key, command, { silent = true, desc = desc, buffer = bufnr })
end

---Set <C-arrow> keys to resize the current window according to its position on
---the screen.
function Config.set_win_resize_keys()
  local modes = { "n", "v", "i", "t" }
  -- stylua: ignore start
  Config.set_keymap(modes, "<C-Up>", function() Config.win_resize("k") end, "Resize window up")
  Config.set_keymap(modes, "<C-Down>", function() Config.win_resize("j") end, "Resize window down")
  Config.set_keymap(modes, "<C-Left>", function() Config.win_resize("h") end, "Resize window left")
  Config.set_keymap(modes, "<C-Right>", function() Config.win_resize("l") end, "Resize window right")
  -- stylua: ignore end
end

---Get the windows layout tree, search the current window node, get its position
---on the tree/screen and execute the proper `resize` command.
---@param direction string
function Config.win_resize(direction)
  local current_win = vim.fn.winnr()
  local resize_cmd = (direction == "h" or direction == "l") and "vertical resize "
    or "resize "

  if direction == "j" or direction == "l" then -- ↓/→
    if current_win == vim.fn.winnr(direction) then
      vim.api.nvim_command(resize_cmd .. "-2")
    else
      vim.api.nvim_command(resize_cmd .. "+2")
    end
  else -- ←/↑
    local opposite = direction == "h" and "l" or "j"

    if current_win == vim.fn.winnr(opposite) then
      vim.api.nvim_command(resize_cmd .. "+2")
    else
      vim.api.nvim_command(resize_cmd .. "-2")
    end
  end
end

---Set <A-arrow> keys to scroll the current window view without moving cursor.
function Config.set_scroll_view_keys()
  local modes = { "n", "v", "i" }
  -- stylua: ignore start
  Config.set_keymap(modes, "<A-Up>", "2<C-y>", "Scroll view up")
  Config.set_keymap(modes, "<A-Down>", "2<C-e>", "Scroll view down")
  Config.set_keymap(modes, "<A-Left>", "4zh", "Scroll view left")
  Config.set_keymap(modes, "<A-Right>", "4zl", "Scroll view right")

  Config.set_keymap(modes, "zh", "4zh", "Scroll view left")
  Config.set_keymap(modes, "zl", "4zl", "Scroll view right")
  -- stylua: ignore end
end

---If vim.opt\[`option`\] is `a`, set it to `b`; otherwise, set it to `a`.
---@param name string Option name to toggle (`vim.o.<option name>`)
---@param opts? {a?:any, b?:any, global?:boolean, silent?:boolean} defaults: `a`: `true`, `b`: `false`, `global`: `false`, `silent`: `false`
function Config.toggle_vim_opt(name, opts)
  local a, b = true, false
  local global, silent
  if opts then
    if opts.a ~= nil then
      a = opts.a
      b = opts.b
    end
    global = opts.global
    silent = opts.silent
  end

  local new_val
  if vim.api.nvim_get_option_value(name, { win = 0 }) == a then
    new_val = b
  else
    new_val = a
  end

  if global == true then
    local current_bufnr = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_set_current_buf(bufnr)
      vim.o[name] = new_val
    end
    vim.api.nvim_set_current_buf(current_bufnr)
  else
    vim.o[name] = new_val
  end
  if silent ~= true then
    vim.notify(string.format("%s%s = %s", global and "global " or "", name, new_val, 2))
  end
end

return Config
