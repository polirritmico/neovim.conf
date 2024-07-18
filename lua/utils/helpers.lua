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
---**Usage:** `:Redir <command>` or `:Redir! <command>`.
---Similar to `:r` but with support for lua functions `:Redir lua foo()`.
---> With bang (!) writes the output into the current buffer at cursor position.
function Helpers.set_redirection_cmd()
  vim.api.nvim_create_user_command("Redir", function(ctx)
    local raw_output = vim.api.nvim_exec2(ctx.args, { output = true }).output
    local output = raw_output:match(".*\r\n\n(.*)") or raw_output
    local splited_output_lines = vim.split(output, "\n", { plain = true })

    if ctx.bang then
      vim.api.nvim_put(splited_output_lines, "l", false, false)
    else
      vim.cmd("enew") -- `new` split the window
      vim.bo.filetype = "lua"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, splited_output_lines)
      vim.opt_local.modified = false
    end
  end, {
    nargs = "+",
    complete = "command",
    bang = true,
    desc = "Redirect cmd output into buffer",
  })
end

return Helpers
