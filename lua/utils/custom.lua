---Utilities to customize Nvim behaviour and functionality.
---@class UtilsCustom
local Custom = {}

local api = vim.api

---Function used to set a custom text when called by a fold action like zc.
---To set it check `:h v:lua-call` and `:h foldtext`.
function Custom.fold_text()
  -- TODO: Get first and last lines highlights
  local first_line = vim.fn.getline(vim.v.foldstart)
  local last_line = vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
  local lines_count = tostring(vim.v.foldend - vim.v.foldstart)
  local space_width = api.nvim_get_option_value("textwidth", {})
    - #first_line
    - #last_line
    - #lines_count
    - 10
  return string.format(
    "%s  %s %s (%d L)",
    first_line,
    last_line,
    string.rep("┈", space_width),
    lines_count
  )
end

---Oil.nvim: Set a configuration key for the confirm changes prompt.
---@param key string Confirmation key.
function Custom.oil_confirmation_key(key)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil_preview",
    callback = function(prms)
      vim.keymap.set("n", key, "Y", { buffer = prms.buf, remap = true, nowait = true })
    end,
  })
end

---Open the app at the path of the current buffer. (Defaults to KDE Dolphin)
---@param app string
function Custom.open_at_buffpath(app)
  app = app or "dolphin"
  vim.fn.jobstart({ app, vim.fn.expand("%:p:h") }, { detach = true })
end

---Restore the cursor to its last position when reopening the buffer.
---Copied from the manual. Check `:h restore-cursor`
function Custom.save_cursor_position_in_file()
  vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]])
end

---Check if `ScratchNotesPath` exists. If not ask for the user to create it.
local function check_ScratchNotesPath()
  if vim.fn.finddir(ScratchNotesPath) == "" then
    local msg = "Missing personal scratch notes path.\nCreate directory? [y/n]: "
    if vim.fn.input(msg):lower() == "y" then
      vim.fn.mkdir(ScratchNotesPath, "p")
    end
  end
end

---Create or open scratch notes through a Telescope picker.
---Defaults to `.md` if no filetype is specified.
function Custom.scratchs()
  check_ScratchNotesPath()

  local state = require("telescope.actions.state")
  local close = require("telescope.actions").close

  local function new_scratch_note(bufnr)
    local scratch = state.get_current_line()
    if not scratch:match("%.") then
      scratch = scratch .. ".md"
    end
    close(bufnr)
    vim.cmd.edit(string.format("%s/%s", ScratchNotesPath, scratch))
  end

  local function open_or_new_scratch_note(bufnr)
    local selection = state.get_selected_entry()
    local scratch = selection and selection[1] or state.get_current_line()
    if not scratch:match("%.") then
      scratch = scratch .. ".md"
    end

    close(bufnr)
    vim.cmd.edit(string.format("%s/%s", ScratchNotesPath, scratch))
  end

  local function open_scratch_directory(bufnr)
    close(bufnr)
    vim.cmd.edit(ScratchNotesPath)
  end

  require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
    prompt_title = "Scratch notes (<S-CR> new | <C-d> dir)",
    no_ignore = true, -- show files ignored by .gitignore
    cwd = ScratchNotesPath,
    attach_mappings = function(_, map)
      map("i", "<Cr>", open_or_new_scratch_note)
      map("i", "<S-CR>", new_scratch_note)
      map("i", "<C-d>", open_scratch_directory)
      return true
    end,
  }))
end

---Return a custom lualine tabline section that integrates Harpoon marks.
---@return string
function Custom.lualine_harpoon()
  local hp_list = require("harpoon"):list()
  local total_marks = hp_list:length()
  if total_marks == 0 then
    return ""
  end

  local hp_keys = { "j", "k", "l", "h" }
  local nvim_mode = api.nvim_get_mode().mode:sub(1, 1)
  local hl_normal = nvim_mode == "n" and "%#lualine_b_normal#"
    or nvim_mode == "i" and "%#lualine_b_insert#"
    or nvim_mode == "c" and "%#lualine_b_command#"
    or "%#lualine_b_visual#"
  local hl_selected = ("v" == nvim_mode or "V" == nvim_mode or "" == nvim_mode)
      and "%#lualine_transitional_lualine_a_visual_to_lualine_b_visual#"
    or "%#lualine_b_diagnostics_warn_normal#"

  local full_name = api.nvim_buf_get_name(0)
  local buffer_name = vim.fn.expand("%")
  local output = " " -- 󰀱

  for index = 1, total_marks <= 4 and total_marks or 4 do
    local mark = hp_list.items[index].value
    -- BUG: Sometimes the buffname is the full path and others the symlink...
    if mark == buffer_name or mark == full_name then
      output = output .. hl_selected .. hp_keys[index] .. hl_normal
    else
      output = output .. hp_keys[index]
    end
  end

  return output
end

---Show/Hide the quickfix list.
function Custom.toggle_quickfix()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

---@class UtilsCustomTermState
---@field win integer
---@field buf integer
---@field open boolean

---@type UtilsCustomTermState?
local term_state

---Open/Close a persistent terminal at the bottom with a fixed height or with
---the `v.count` height passed before the shortcut, e.g., `20<toggle_term-map>`.
function Custom.toggle_term()
  -- TODO: Hide buffer from the list (:Telescope buffers)
  local height = vim.v.count > 0 and vim.v.count or 12
  local function set_window_panel()
    vim.cmd.new()
    vim.cmd.wincmd("J")
    local win = api.nvim_get_current_win()
    api.nvim_win_set_height(win, height)
    vim.wo.winfixheight = true
    return win
  end

  if not term_state then
    -- new terminal panel
    term_state = {
      win = set_window_panel(),
      buf = api.nvim_get_current_buf(),
      open = true,
    }
    vim.cmd.term()
  elseif not term_state.open then
    -- reopen the closed terminal panel
    term_state.win = set_window_panel()
    -- TODO: Avoid listing the buffer, so `:bn` dont open the terminal
    -- api.nvim_set_option_value("bufhidden", "hide", { buf = term_state.buf })
    api.nvim_win_set_buf(term_state.win, term_state.buf)
    term_state.open = true
    vim.cmd.startinsert()
  elseif api.nvim_win_is_valid(term_state.win) then
    -- close the terminal panel
    api.nvim_win_close(term_state.win, true)
    term_state.open = false
  else
    -- the terminal panel has been closed externally
    term_state = nil
    Custom.toggle_term()
  end
end

return Custom
