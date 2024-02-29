local M = {}

---Sets up an autocmd to create a custom mapping for the passed filetype.
---
---This function automatically creates a custom mapping defined by the provided
---`keymap` when the specified `filetype` is detected. When pressed the mapping,
---it run the passed external command (`ext_cmd`) over the current buffer.
---@param filetype string Filetype extension
---@param keymap string Mapping that is going to trigger the command
---@param ext_cmd string Command to run the file. Should begin with "`!`" and end with "` %`".
function M.set_autocmd_runner(filetype, keymap, ext_cmd)
  local cmd = "noremap " .. keymap .. " <Cmd>" .. ext_cmd .. "<CR>"
  vim.api.nvim_create_autocmd({ "FileType" }, {
    command = cmd,
    group = vim.api.nvim_create_augroup("UserAutocmd_" .. filetype, {}),
    pattern = filetype,
  })
end

---Sets an autocmd that evaluate the shebang of `sh` files and set the filetype
---to `bash` if matches.
function M.set_bash_ft_from_shebang()
  local augroup = "ShebangFtDetection"
  vim.api.nvim_create_augroup(augroup, { clear = false })
  vim.api.nvim_create_autocmd({ "Filetype" }, {
    desc = "For `*.sh` files set the filetype based on the shebang header line.",
    group = augroup,
    pattern = { "sh" },
    callback = function()
      local line = vim.fn.getline(1)
      local pattern1, pattern2 = "^#!.*/bin/env%s+bash", "^#!.*/bin/bash"
      if string.match(line, pattern1) or string.match(line, pattern2) then
        vim.api.nvim_set_option_value("filetype", "bash", { buf = 0 })
      end
    end,
  })
end

return M
