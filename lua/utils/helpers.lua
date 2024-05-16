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
function Helpers.custom_print(...)
  local args = { ... }
  local mapped = {}
  for _, variable in pairs(args) do
    table.insert(mapped, vim.inspect(variable))
  end
  print(unpack(mapped))

  return unpack(args)
end

---Replicate the `gx` functionality from Netrw
function Helpers.open_url()
  -- TODO: Remove when updating to 0.10: https://github.com/neovim/neovim/pull/23401
  local pattern = [[https?://[%w-_%.%?%.:/%+=&]+[^ >"\',;`]*]]
  local current_str = vim.fn.expand("<cfile>") -- or cWORD?
  local url = string.match(current_str, pattern)
  if not url then
    local msg = string.format("Can't detect url for [%s]", current_str)
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  local cmd_output = vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  if cmd_output <= 0 then
    vim.notify(string.format("Error opening '%s'.", url), vim.log.levels.ERROR)
  end
end

---Redirects the output of the passed command-line into a new buffer
--- **Usage:** `:Redir <the command>`
function Helpers.set_cmd_redirection()
  vim.api.nvim_create_user_command("Redir", function(ctx)
    local cmd_output = vim.api.nvim_exec(ctx.args, { output = true })
    local lines = vim.split(cmd_output, "\n", { plain = true })
    vim.cmd("enew") -- `new` split the window
    vim.bo.filetype = "lua"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
  end, { nargs = "+", complete = "command" })
end

---Telescope action helper to open single or multiple files
---@param bufnr integer telescope prompt buffer number
function Helpers.telescope_open_single_and_multi(bufnr)
  local picker = require("telescope.actions.state").get_current_picker(bufnr)
  local selection = picker:get_multi_selection()
  if not vim.tbl_isempty(selection) then
    require("telescope.actions").close(bufnr)
    for _, file in pairs(selection) do
      if file.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", file.path))
      end
    end
  else
    require("telescope.actions").select_default(bufnr)
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
  if vim.api.nvim_win_get_option(0, option) == a then
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
