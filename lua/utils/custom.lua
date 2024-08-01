---Utilities to customize Nvim behaviour and functionality.
---@class UtilsCustom
local Custom = {}

local api = vim.api

---Copies the _last edited_ register (`".`) to the `"d` register and simulates
---a macro recording for use with `Q`.
function Custom.dot_to_register()
  vim.cmd([[
    let reg_val = getreg('.') | normal! qdq
    call setreg('d', 'ciw' . reg_val . "\<Esc>")
  ]])
end

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

---Open the application at the path of the current buffer. (Defaults to KDE Dolphin)
---@param app string
function Custom.open_at_buffpath(app)
  app = app or "dolphin"
  vim.fn.jobstart({ app, vim.fn.expand("%:p:h") }, { detach = true })
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
    vim.cmd.edit(ScratchNotesPath .. scratch)
  end

  local function open_or_new_scratch_note(bufnr)
    local selection = state.get_selected_entry()
    local scratch = selection and selection[1] or state.get_current_line()
    if not scratch:match("%.") then
      scratch = scratch .. ".md"
    end

    close(bufnr)
    vim.cmd.edit(ScratchNotesPath .. scratch)
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

---@class UtilsCustomTermState:nil
---@field win integer
---@field buf integer
---@field height integer
---@field open boolean
local term_state

---Open/Close a persistent terminal at the bottom with a fixed height or with
---the `v.count` height passed before the shortcut, e.g., `20<toggle_term-map>`.
function Custom.toggle_term()
  local height = vim.v.count > 0 and vim.v.count
    or term_state and term_state.height
    or 12

  local function set_panel_window()
    vim.cmd.new()
    vim.cmd.wincmd("J")
    local win = api.nvim_get_current_win()
    api.nvim_win_set_height(win, height)
    vim.wo.winfixheight = true
    return win
  end

  local function set_buffterm_opts()
    assert(term_state, "Error: Setting panel buffer options but term_state is nil")
    api.nvim_set_option_value("buftype", "terminal", { buf = term_state.buf })
    api.nvim_set_option_value("bufhidden", "hide", { buf = term_state.buf })
    api.nvim_set_option_value("buflisted", false, { buf = term_state.buf })
  end

  ---@return boolean previous_term_detected Return `true` if there's currently a opened terminal buffer
  local function set_term_state()
    local window, bufnr

    local previous_term_detected = false
    for _, _window in ipairs(vim.api.nvim_list_wins()) do
      local _bufnr = api.nvim_win_get_buf(_window)
      local buftype = api.nvim_get_option_value("buftype", { buf = _bufnr })
      if buftype == "terminal" then
        previous_term_detected = true
        window = _window
        bufnr = _bufnr
        break
      end
    end

    term_state = {
      win = window or set_panel_window(),
      buf = bufnr or api.nvim_get_current_buf(),
      height = height,
      open = true,
    }
    if previous_term_detected then
      set_buffterm_opts()
    end
    return previous_term_detected
  end

  local function new_terminal()
    assert(term_state, "Error: Creating terminal panel but term_state is nil")
    vim.cmd.term()
    set_buffterm_opts()
  end

  local function close_terminal()
    assert(term_state, "Error: Closing terminal panel but term_state is nil")
    if #vim.api.nvim_list_wins() == 1 then
      vim.notify("Can't close last window")
      return
    end
    api.nvim_win_close(term_state.win, true)
    term_state.open = false
  end

  local function reopen_terminal()
    assert(term_state, "Error: Re-opening terminal panel but term_state is nil")
    term_state.win = set_panel_window()
    api.nvim_win_set_buf(term_state.win, term_state.buf)
    term_state.open = true
    vim.cmd.startinsert()
  end

  if not term_state then
    local previous_term_detected = set_term_state()
    if previous_term_detected then
      close_terminal()
    else
      new_terminal()
    end
  elseif not term_state.open then
    reopen_terminal()
  elseif api.nvim_win_is_valid(term_state.win) then
    close_terminal()
  else
    term_state = nil
    Custom.toggle_term()
  end
end

return Custom
