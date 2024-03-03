local M = {}

---Replace for <C-g> to get the full current buffer path
function M.buffer_info()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local percentage = math.floor(line * 100 / vim.fn.line("$"))
  vim.notify(string.format([["%s" %i lines --%i%%--]], file, line, percentage))
end

---Function used to set a custom text when called by a fold action like zc.
---To set it check `:h v:lua-call` and `:h foldtext`.
function M.fold_text()
  local first_line = vim.fn.getline(vim.v.foldstart)
  local last_line = vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
  local lines_count = tostring(vim.v.foldend - vim.v.foldstart)
  local space_width = vim.api.nvim_get_option("textwidth")
    - #first_line
    - #last_line
    - #lines_count
    - 10
  return string.format(
    "%s  %s %s (%d L)",
    first_line,
    last_line,
    string.rep(".", space_width),
    lines_count
  )
end

---Highlight the yanked/copied text. Uses the event `TextYankPost` and the
---group name `User/TextYankHl`.
---@param on_yank_opts? table Options for the on_yank function. Check `:h on_yank for help`.
function M.highlight_yanked_text(on_yank_opts)
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("User/TextYankHl", { clear = true }),
    desc = "Highlight yanked text",
    callback = function() vim.highlight.on_yank(on_yank_opts) end,
  })
end

---Keeps the current buffer position across sessions.
function M.save_cursor_position()
  vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]])
end

---Show/Hide the fold column at the left of the line numbers.
function M.toggle_fold_column()
  if vim.api.nvim_win_get_option(0, "foldcolumn") == "0" then
    vim.opt.foldcolumn = "auto:3"
  else
    vim.opt.foldcolumn = "0"
  end
end

return M
