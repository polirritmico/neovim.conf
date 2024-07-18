---Functions helpers used to configure plugins.
---@class UtilsPlugins
local Plugins = {}

---Add a Telescope picker to use MiniSessions functions
function Plugins.mini_sessions_manager()
  local mini_sessions = require("mini.sessions")
  local opts = {
    cwd = mini_sessions.config.directory,
    results_title = "Sessions Manager",
    prompt_title = "<CR>:Open  <C-s>:Save  <C-r>:Remove",
    previewer = false,
    layout_config = { height = { 0.6, max = 21 }, width = { 0.99, max = 65 } },
  }
  ---@type table<string, ActionInstruction>
  local instructions = {
    ["<CR>"] = { func = mini_sessions.read, entry = 1, close = false },
    ["<C-s>"] = { func = mini_sessions.write },
    ["<C-r>"] = { func = mini_sessions.delete, entry = 1 },
  }
  Plugins.telescope_wrapper(instructions, opts, "sessions")
end

---Telescope action helper to pass the current matches into another telescope
---instance. `live_grep` by default. If is a `live_grep`, then pass the matches
---into a `find_files` picker.
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_narrow_matches(bufnr)
  local builtin = require("telescope.builtin")
  local actions_state = require("telescope.actions.state")
  local map_entries = require("telescope.actions.utils").map_entries
  local matches = {}

  if actions_state.get_current_picker(bufnr).prompt_title ~= "Live Grep" then
    map_entries(bufnr, function(entry) table.insert(matches, entry[0] or entry[1]) end)
    builtin.live_grep({ search_dirs = matches })
  else
    map_entries(bufnr, function(entry) table.insert(matches, entry.filename) end)
    builtin.find_files({ search_dirs = matches })
  end
end

---Telescope action helper to open a qflist with all current matches and open
---the first entry.
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_open_and_fill_qflist(bufnr)
  local actions = require("telescope.actions")
  actions.send_to_qflist(bufnr)
  actions.open_qflist(bufnr)
  vim.api.nvim_input("<CR>")
end

---Telescope action helper to open single or multiple files
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_open_single_and_multi(bufnr)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local single_selection = actions_state.get_selected_entry()
  local multi_selection = actions_state.get_current_picker(bufnr):get_multi_selection()
  if not vim.tbl_isempty(multi_selection) then
    actions.close(bufnr)
    for _, file in pairs(multi_selection) do
      if file.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", file.path))
      end
    end
    vim.cmd(string.format("%s %s", "edit", single_selection.path))
  else
    actions.select_default(bufnr)
  end
end

Plugins.constructed_pickers = {}

---@alias ActionInstruction { func:function, entry?:string|integer, close?:boolean }
---Telescope helper wrapper for builtin pickers.
---@param instructions table<string, ActionInstruction> List of functions to be executed and the field from the entries. If the field is nil, then the current input text field from the picker is used.
---@param opts table Telescope picker options
---@param cache_name string Name used to store the picker in the constructed_pickers
---@param picker_name? string Defaults to `find_files`
function Plugins.telescope_wrapper(instructions, opts, cache_name, picker_name)
  -- Dont build every time
  if Plugins.constructed_pickers[cache_name] then
    Plugins.constructed_pickers[cache_name]()
    return
  end

  picker_name = picker_name or "find_files"
  local picker = require("telescope.builtin")[picker_name]
  if not picker then
    vim.notify("telescope_wrapper: nil picker " .. picker_name, vim.log.levels.ERROR)
    return
  end
  local tl_actions = require("telescope.actions")
  local tl_state = require("telescope.actions.state")

  ---Build telescope a action from the instruction
  ---@param instruction ActionInstruction
  ---@return function
  local function construct_action(instruction)
    local get_value
    if not instruction.entry then
      get_value = tl_state.get_current_line
    else
      get_value = function()
        local selected = tl_state.get_selected_entry()
        if not selected or not selected[instruction.entry] then
          error("Error: Empty selection or selection does not exists")
        else
          return selected[instruction.entry]
        end
      end
    end

    return function(bufnr)
      local ok, value = pcall(get_value, bufnr)
      if not ok then
        vim.notify(value, vim.log.levels.WARN)
        return
      end
      instruction.func(value)
      if instruction.close ~= false then
        tl_actions.close(bufnr)
      end
    end
  end

  opts.attach_mappings = function(_, map)
    for key, instruction in pairs(instructions) do
      local action = construct_action(instruction)
      map("i", key, action)
    end

    return true
  end

  Plugins.constructed_pickers[cache_name] = function() picker(opts) end
  Plugins.constructed_pickers[cache_name]()
end

return Plugins
