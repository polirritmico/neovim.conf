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

---Helper function to check if a file exists and return its path or a global.
---@param file string Filename or cmd to check in the passed path
---@param path string? Relative path, **must begin and end with "/"**.
---@param cwd boolean? Prepend the current working dir to the path (default true).
---@return string -- The path/file if file found or the file
function Helpers.local_or_global(file, path, cwd)
  local localpath = (cwd == false and "" or vim.fn.getcwd()) .. (path or "/") .. file
  local file_status = vim.uv.fs_stat(localpath)
  return (file_status and file_status.type == "file") and localpath or file
end

---Open the application at the path of the current buffer. (Defaults to KDE Dolphin)
---@param app string
function Helpers.open_at_buffpath(app)
  app = app or "dolphin"
  vim.system({ app, vim.fn.expand("%:p:h") }, { detach = true })
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
