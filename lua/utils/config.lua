---Functions helpers used to configure Neovim.
---@class UtilsConfig
local Config = {}

---Wrapper to center the screen after vim.lsp.buf.definition asyncronous
---execution: `gd` -> `gdzz`.
---@return function
function Config.lsp_definition_centered()
  local method = "textDocument/definition"
  local definiton_handler = require("vim.lsp.handlers")[method]
  local mk_position_params = require("vim.lsp.util").make_position_params
  return function()
    vim.lsp.buf_request(0, method, mk_position_params(), function(...)
      definiton_handler(...)
      vim.api.nvim_feedkeys("zz", "n", true)
    end)
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

---Set <C-arrow> keys to resize the current window according to its position on
---the screen.
function Config.set_win_resize_keys()
  -- stylua: ignore start
  Config.set_keymap("n", "<C-Up>", function() Config.win_resize("k") end, "Resize window")
  Config.set_keymap("n", "<C-Down>", function() Config.win_resize("j") end, "Resize window")
  Config.set_keymap("n", "<C-Left>", function() Config.win_resize("h") end, "Resize window")
  Config.set_keymap("n", "<C-Right>", function() Config.win_resize("l") end, "Resize window")
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
