---Utilities to customize Nvim behaviour and functionality.
---@class UtilsCustom
local Custom = {}

local api = vim.api

---Function used to set a custom text when called by a fold action like zc.
---To set it check `:h v:lua-call` and `:h foldtext`.
function Custom.fold_text()
  local first_line = vim.fn.getline(vim.v.foldstart)
  local last_line = vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
  local lines_count = tostring(vim.v.foldend - vim.v.foldstart)
  local space_width = api.nvim_get_option("textwidth")
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

---Highlight the yanked/copied text. Uses the event `TextYankPost` and the
---group name `User/TextYankHl`.
---@param on_yank_opts? table Options for the on_yank function. Check `:h on_yank for help`.
function Custom.highlight_yanked_text(on_yank_opts)
  api.nvim_create_autocmd("TextYankPost", {
    group = api.nvim_create_augroup("User/TextYankHl", { clear = true }),
    desc = "Highlight yanked text",
    callback = function() vim.highlight.on_yank(on_yank_opts) end,
  })
end

---Restore the cursor position when last exiting the current buffer.
---Copied from the manual. Check `:h restore-cursor`
function Custom.save_cursor_position()
  vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]])
end

---Create an autocommand to launch a plugin file browser when opening dirs.
---@param plugin_name string
---@param plugin_open fun(path: string) Function to open the file browser
function Custom.attach_file_browser(plugin_name, plugin_open)
  local previous_buffer_name
  api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("UserFileBrowser", { clear = true }),
    pattern = "*",
    callback = function()
      vim.schedule(function()
        local buffer_name = api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(buffer_name) == 0 then
          _, previous_buffer_name = pcall(vim.fn.expand, "#:p:h")
          return
        end

        -- Avoid reopening when exiting without selecting a file
        if previous_buffer_name == buffer_name then
          previous_buffer_name = nil
          return
        else
          previous_buffer_name = buffer_name
        end

        -- Ensure no buffers remain with the directory name
        api.nvim_buf_set_option(0, "bufhidden", "wipe")
        plugin_open(vim.fn.expand("%:p:h"))
      end)
    end,
    desc = string.format("[%s] replacement for netrw", plugin_name),
  })
end

---Create a buffer for taking notes into a scratch buffer
--- **Usage:** `Scratch`
function Custom.set_create_scratch_buffers()
  api.nvim_create_user_command("Scratch", function()
    vim.cmd("bel 10new")
    local buf = api.nvim_get_current_buf()
    local opts = {
      -- `:h scratch-buffer`
      buftype = "nofile",
      bufhidden = "hide",
      swapfile = false,
      filetype = "scratch",
      modifiable = true,
    }
    for key, value in pairs(opts) do
      api.nvim_set_option_value(key, value, { buf = buf })
    end
  end, { desc = "Create a scratch buffer" })
end

---Return a custom lualine tabline section that integrates Harpoon marks.
---@return string
function Custom.lualine_harpoon()
  local hp_list = require("harpoon"):list()
  local total_marks = hp_list:length()
  if total_marks == 0 then
    return ""
  end

  local nvim_mode = api.nvim_get_mode().mode:sub(1, 1)
  local hp_keymap = { "j", "k", "l", "h" }
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
    if mark == buffer_name or mark == full_name then
      output = output .. hl_selected .. hp_keymap[index] .. hl_normal
    else
      output = output .. hp_keymap[index]
    end
  end

  return output
end

---Show/Hide the quickfix list
function Custom.toggle_quickfix()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

local term_state

---Open/Close a persistent terminal at the bottom with a fixed height or with
---the `v.count` height passed before the shortcut, e.g., `20<toggle_term-map>`.
function Custom.toggle_term()
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
