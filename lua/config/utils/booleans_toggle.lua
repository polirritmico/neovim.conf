local M = {}

M.base_booleans = {
  { "Enable", "Disable" },
  { "Enabled", "Disabled" },
  { "On", "Off" },
  { "True", "False" },
  { "Yes", "No" },
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

---@param increment boolean|nil
function M.toggle(increment)

  -- local original_position = vim.api.nvim_win_get_cursor(0)
  -- local current_char_pos = original_position[2] -- cursor col is 0 index
  -- local line = vim.api.nvim_get_current_line()
  -- local line_size = vim.fn.strlen(line)
  -- local cword = vim.fn.expand("<cword>") ---@type string|nil
  -- local cword_raw = vim.fn.expand("<cWORD>")
  -- local cmd_count = vim.v.count > 1 and vim.v.count or ""
  -- local test = "no"
  --
  -- local function sync_cword_with_cword_raw()
  --   return string.find(cword_raw, cword or " ") and true or false
  -- end
  --
  -- local function next_word()
  --   current_char_pos = vim.api.nvim_win_get_cursor(0)[2]
  --   local cword_size = vim.fn.strlen(cword or "")
  --
  --   if current_char_pos + cword_size >= line_size then
  --     return nil
  --   end
  --
  --   cword = vim.fn.expand("<cword>")
  --   cword_raw = vim.fn.expand("<cWORD>")
  --
  --   return vim.cmd("normal! w")
  -- end
  --
  -- P("Into the loop:")
  -- while cword do
  --   P("cword: ", cword)
  --   if tonumber(cword) or string.match(cword, "%d") ~= nil then
  --     if increment then
  --       return vim.cmd("normal!" .. cmd_count .. "")
  --     else
  --       return vim.cmd("normal!" .. cmd_count .. "")
  --     end
  --   end
  --   local substitution = M.booleans[cword]
  --   P("substitution match: ", substitution)
  --   if substitution then
  --     vim.cmd('normal! "_ciw' .. substitution)
  --     vim.cmd("normal! b")
  --     P("changed!")
  --     return
  --   end
  --   cword = next_word()
  -- end
  -- P("out the loop")
  -- vim.api.nvim_win_set_cursor(0, original_position)
end

function M.toggle_inc()
  M.toggle(true)
end
function M.toggle_dec()
  M.toggle()
end

vim.keymap.set({ "n", "v" }, "", M.toggle_inc)
vim.keymap.set({ "n", "v" }, "", M.toggle_dec)

-- return M
