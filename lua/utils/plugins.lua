---Functions helpers used to configure plugins.
---@class UtilsPlugins
local Plugins = {}

---A custom Telescope picker to use MiniSessions actions
function Plugins.mini_sessions_manager()
  local mini_sessions = require("mini.sessions")
  local tlstate = require("telescope.actions.state")
  local close = require("telescope.actions").close
  local theme = require("telescope.themes").get_dropdown

  ---@return string?, string?
  local function get_user_input()
    local selected = tlstate.get_selected_entry()
    local input_text = tlstate.get_current_line()
    selected = selected and selected[1] or nil
    input_text = input_text ~= "" and input_text or nil
    return selected, input_text
  end

  ---@param filename string?
  local function write_session(bufnr, filename)
    if not filename then
      local selected, input_text = get_user_input()
      filename = selected or input_text
    end

    if not filename or filename == "" then
      vim.notify("write_session: Empty or nil filename", vim.log.levels.WARN)
    elseif vim.fn.findfile(vim.fn.expand(filename)) == "" then
      close(bufnr)
      mini_sessions.write(filename)
    elseif vim.fn.input("Overwrite session? [y/n]: "):lower() == "y" then
      close(bufnr)
      mini_sessions.write(filename)
    else
      vim.notify("Aborted", vim.log.levels.INFO)
    end
  end

  local function delete_session(bufnr)
    local selected, _ = get_user_input()
    if not selected then
      vim.notify("delete_session: Empty selection", vim.log.levels.WARN)
    elseif vim.fn.input("Delete session? [y/n]: "):lower() == "y" then
      mini_sessions.delete(selected, { force = true })
      close(bufnr)
    else
      vim.notify("Aborted", vim.log.levels.INFO)
    end
  end

  local function read_or_write_session(bufnr)
    local selected, input_text = get_user_input()

    if not selected and not input_text then
      vim.notify("Empty selection and input text", vim.log.levels.INFO)
    elseif not selected and input_text then
      write_session(bufnr, input_text)
    elseif selected and not input_text then
      mini_sessions.read(selected)
    elseif selected == input_text then
      mini_sessions.read(selected)
    else -- user must decide
      local msg = string.format(
        "Choose 'r' to read '%s' or 'w' to write '%s': ",
        selected,
        input_text
      )
      local user_input = vim.fn.input(msg):lower()

      if user_input == "w" then
        write_session(bufnr, input_text)
      elseif user_input == "r" then
        mini_sessions.read(selected)
      end
    end
  end

  -- Build the picker
  local opts = {
    cwd = mini_sessions.config.directory,
    results_title = "Sessions Manager",
    prompt_title = "<CR>:Open  <C-w>:Write  <C-d>:Delete",
    previewer = false,
    layout_config = { height = { 0.6, max = 21 }, width = { 0.99, max = 65 } },
    attach_mappings = function(_, map)
      map("i", "<CR>", read_or_write_session)
      map("i", "<C-w>", write_session)
      map("i", "<C-d>", delete_session)
      map("i", "<ESC>", close)
      map("i", "<C-n>", "move_selection_next")
      map("i", "<C-p>", "move_selection_previous")
      return false -- false to only use attached mappings
    end,
  }
  require("telescope.builtin").find_files(theme(opts))
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

return Plugins
