---Utilities to customize Nvim behaviour and functionality.
---@class UtilsCustom
local Custom = {}

local api = vim.api

---Get the treesitter highlights of the passed line (no syntactic tokens)
---@param linenr integer 0-idx line number
---@return table<string, string>[] line_highlights
local function get_ts_line_highlights(line, linenr)
  local line_hls = {}
  local ts_highlights = vim.treesitter.get_captures_at_pos

  local current_text = ""
  local previous_hl
  for i = 1, #line do
    local current_char = line:sub(i, i)
    local hl_capture = ts_highlights(0, linenr, i - 1)
    if #hl_capture < 1 then
      current_text = current_text .. current_char
    else
      local current_hl = "@" .. hl_capture[#hl_capture].capture
      if current_hl == previous_hl then
        current_text = current_text .. current_char
      else
        line_hls[#line_hls + 1] = { current_text, previous_hl }
        current_text = current_char
        previous_hl = current_hl
      end
    end
  end
  line_hls[#line_hls + 1] = { current_text, previous_hl }
  return line_hls
end

---@type table<string, { line: integer, content: string[] }>
local fold_cache = {}

---Function used to set a custom text when called by a fold action like `zc`.
---To set it check `:h v:lua-call` and `:h foldtext`.
---
---This function is **heavily** used, so we store the formatted folds in the
---`fold_cache` table to improve the performance a little.
function Custom.fold_text()
  local first_linenr, last_linenr = vim.v.foldstart, vim.v.foldend -- both 1-idx
  local first_line = vim.fn.getline(first_linenr)

  if fold_cache[first_line] and fold_cache[first_line].line == last_linenr then
    return fold_cache[first_line].content
  end

  local last_line = vim.fn.getline(last_linenr):gsub("^%s*", "")
  local lines_count = tostring(last_linenr - first_linenr)
  local filler = string.rep(
    "┈",
    api.nvim_get_option_value("textwidth", {})
      - #first_line
      - #last_line
      - #lines_count
      - 10
  )

  local fold_header_hl = get_ts_line_highlights(first_line, first_linenr - 1)
  local fold_footer_hl = get_ts_line_highlights(last_line, last_linenr - 1)

  local res = {}
  vim.list_extend(res, fold_header_hl)
  res[#res + 1] = { "  ", "Fold" }
  vim.list_extend(res, fold_footer_hl)
  res[#res + 1] = { string.format(" %s (%d L)", filler, lines_count), "Fold" }

  fold_cache[first_line] = { line = last_linenr, content = res }
  return res
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
    for _, _window in ipairs(api.nvim_list_wins()) do
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
    if #api.nvim_list_wins() == 1 then
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
