---Helper functions used to facilitate commonly used Nvim operations
---@class UtilsHelpers
local Helpers = {}

---Set the current working directory to the location of the current buffer
function Helpers.buffer_path_to_cwd()
  local buffer_path = vim.fn.expand("%:p:h")
  if buffer_path then
    vim.api.nvim_set_current_dir(buffer_path)
    vim.notify(string.format("New cwd: %s", buffer_path))
  end
end

---Give execution permissions to the current buffer if its filetype is in the list
---@param valid_filetypes table<string> Table of accepted filetypes
function Helpers.chmod_exe(valid_filetypes)
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

---Wrapper function to pretty print variables instead of getting memory addresses.
---@param ... any Variable or variables to pretty print
---@return any -- Return the variables unpacked
function Helpers.print_wrapper(...)
  local args = { ... }
  local mapped = {}
  for _, variable in pairs(args) do
    table.insert(mapped, vim.inspect(variable))
  end
  print(unpack(mapped))

  return unpack(args)
end

---Redirects the output of the passed command-line into a buffer.
---**Usage:** `:Redir <command>` or `:Redir! <command>`. With bang writes into
---the current buffer at cursor position. For Lua: `:Redir lua foo()`.
function Helpers.set_redirection_cmd()
  vim.api.nvim_create_user_command("Redir", function(ctx)
    local cmd_output = vim.api.nvim_exec2(ctx.args, { output = true }).output
    local lines = vim.split(cmd_output, "\n", { plain = true })
    if ctx.bang then
      -- local linenr = vim.api.nvim_win_get_cursor(0)[1]
      -- vim.api.nvim_buf_set_lines(0, linenr, linenr + #lines, false, lines)
      vim.api.nvim_put(lines, "l", true, true)
    else
      vim.cmd("enew") -- `new` split the window
      vim.bo.filetype = "lua"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.opt_local.modified = false
    end
  end, {
    nargs = "+",
    complete = "command",
    bang = true,
    desc = "Redirect cmd output into buffer",
  })
end

---Telescope action helper to pass the current matches into a live_grep instance.
---@param bufnr integer Telescope prompt buffer number
function Helpers.telescope_matches_to_live_grep(bufnr)
  local map_entries = require("telescope.actions.utils").map_entries
  local matches = {}
  map_entries(bufnr, function(entry) table.insert(matches, entry[0] or entry[1]) end)
  require("telescope.builtin").live_grep({ search_dirs = matches })
end

---Telescope action helper to open a qflist with all current matches and open
---the first entry.
---@param bufnr integer Telescope prompt buffer number
function Helpers.telescope_open_and_fill_qflist(bufnr)
  local actions = require("telescope.actions")
  actions.send_to_qflist(bufnr)
  actions.open_qflist(bufnr)
  vim.api.nvim_input("<CR>")
end

---Telescope action helper to open single or multiple files
---@param bufnr integer Telescope prompt buffer number
function Helpers.telescope_open_single_and_multi(bufnr)
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

---Set vim.opt\[`option`\] to `b` if its current value is `a` or to `a` otherwise
---@param option string `vim.o.<option>` to toggle
---@param a any Defaults to `true`
---@param b any Defaults to `false`
---@param silent boolean? Defaults to `false`
function Helpers.toggle_vim_opt(option, a, b, silent)
  if a == nil and b == nil then
    a, b = true, false
  end

  local new_opt
  if vim.api.nvim_get_option_value(option, { win = 0 }) == a then
    new_opt = b
  else
    new_opt = a
  end
  vim.opt[option] = new_opt

  if silent ~= false then
    vim.notify(string.format("%s = %s", option, new_opt), vim.log.levels.INFO)
  end
end

return Helpers
