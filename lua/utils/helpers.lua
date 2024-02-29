local M = {}

---Give execution permissions to the current buffer if its filetype is in the list
---@param valid_filetypes table<string> Table of accepted filetypes
function M.chmod_exe(valid_filetypes)
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
function M.custom_print(...)
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
function M.set_cmd_redirection()
  vim.api.nvim_create_user_command("Redir", function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
    vim.cmd("enew") -- `new` split the window
    vim.bo.filetype = "lua"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
  end, { nargs = "+", complete = "command" })
end

---Create a buffer for taking notes into a scratch buffer
--- **Usage:** `Scratch`
function M.set_create_scratch_buffers()
  vim.api.nvim_create_user_command("Scratch", function()
    vim.cmd("bel 10new")
    local buf = vim.api.nvim_get_current_buf()
    local opts = {
      bufhidden = "hide",
      buftype = "nofile",
      filetype = "scratch",
      modifiable = true,
      swapfile = false,
    }
    for key, value in pairs(opts) do
      vim.api.nvim_set_option_value(key, value, { buf = buf })
    end
  end, { desc = "Create a scratch buffer" })
end

return M
