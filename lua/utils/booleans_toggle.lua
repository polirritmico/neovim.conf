local M = {}

---@type table The `key` is a boolean value string, and the `value` its opposite.
M.base_booleans = {
  { "True", "False" },
  { "Yes", "No" },
  { "On", "Off" },
}

M.booleans = {}

function M.generate_booleans()
  for _, tbl in pairs(M.base_booleans) do
    M.booleans[tbl[1]] = tbl[2]
    M.booleans[tbl[2]] = tbl[1]
    M.booleans[tbl[1]:lower()] = tbl[2]:lower()
    M.booleans[tbl[2]:lower()] = tbl[1]:lower()
    M.booleans[tbl[1]:upper()] = tbl[2]:upper()
    M.booleans[tbl[2]:upper()] = tbl[1]:upper()
  end
end

M.generate_booleans()

---Explore the current line from the cursor position and replace the first
---matching word from the booleans table with its opposite.
---The function aims to imitate the builtin <C-a>/<C-x> functionality but in
---addition to increment/decrement the first number, it would toggle between
---the first matching booleans.
---@param increment boolean Pass `true` to increment, `false` otherwise.
function M.toggle(increment)
  local cmd_count = vim.v.count > 1 and vim.v.count or ""
  local original_position = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_size = vim.fn.strlen(line)

  local current_line = original_position[1]
  local current_char_pos = original_position[2] -- cursor col is 0 index
  local curstr = ""
  local cword = ""

  -- `cword` is taken from `:h cword`. It should be the word under the cursor,
  -- but if e.g., the cursor is in the space before the word or over some symbol
  -- like " or =, then it would also include the next word. Thats why `curstr`
  -- is needed. `curstr` would actually show what is under the cursor. However,
  -- the problem is that it also includes other symbols surrounding the word.
  -- This is why we need both to be in sync to ensure the cursor is over the
  -- correct word and apply the `"_ciw` command where appropriate.

  local function update_current_words()
    local current_pos = vim.api.nvim_win_get_cursor(0)
    current_line = current_pos[1]
    current_char_pos = current_pos[2]
    curstr = vim.fn.matchstr(line, "\\k*", current_char_pos)
    cword = vim.fn.expand("<cword>")
  end

  update_current_words()
  local max_loops_counter = 0
  while current_char_pos + 1 <= line_size and current_line == original_position[1] do
    if tonumber(cword) or string.match(cword, "%d") ~= nil then
      if increment then
        return vim.cmd("normal!" .. cmd_count .. "")
      else
        return vim.cmd("normal!" .. cmd_count .. "")
      end
    end

    if curstr ~= "" and string.find(cword, curstr) then
      local opposite = M.booleans[cword]
      if opposite then
        vim.cmd('normal! "_ciw' .. opposite)
        return
      end
    end

    vim.cmd("normal! w")
    update_current_words()

    max_loops_counter = max_loops_counter + 1
    if max_loops_counter > 300 then
      vim.notify("Toggle boolean: Maximum loops reached", vim.log.levels.WARN)
      break
    end
  end
  vim.api.nvim_win_set_cursor(0, original_position)
end

vim.keymap.set({ "n", "v" }, "", function() M.toggle(true) end)
vim.keymap.set({ "n", "v" }, "", function() M.toggle(false) end)

return M
