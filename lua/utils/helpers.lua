---Helper functions used to facilitate commonly used Nvim operations
---@class UtilsHelpers
local Helpers = {}

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
---@return any # Return the variables unpacked
function Helpers.custom_print(...)
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

---Replace for <C-g> to get the full current buffer path
function Helpers.buffer_info()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local percentage = math.floor(line * 100 / vim.fn.line("$"))
  vim.notify(string.format([["%s" %i lines --%i%%--]], file, line, percentage))
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

  if silent == nil or silent ~= false then
    vim.notify(string.format("%s = %s", option, new_opt), vim.log.levels.INFO)
  end
end

return Helpers
