---Utilities to customize Nvim behaviour and functionality.
---@class UtilsCustom
local Custom = {}

---Function used to set a custom text when called by a fold action like zc.
---To set it check `:h v:lua-call` and `:h foldtext`.
function Custom.fold_text()
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
    string.rep("┈", space_width),
    lines_count
  )
end

---Highlight the yanked/copied text. Uses the event `TextYankPost` and the
---group name `User/TextYankHl`.
---@param on_yank_opts? table Options for the on_yank function. Check `:h on_yank for help`.
function Custom.highlight_yanked_text(on_yank_opts)
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("User/TextYankHl", { clear = true }),
    desc = "Highlight yanked text",
    callback = function() vim.highlight.on_yank(on_yank_opts) end,
  })
end

---Keeps the current buffer position across sessions.
function Custom.save_cursor_position()
  vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]])
end

---Show/Hide the fold column at the left of the line numbers.
function Custom.toggle_fold_column()
  if vim.api.nvim_win_get_option(0, "foldcolumn") == "0" then
    vim.opt.foldcolumn = "auto:3"
  else
    vim.opt.foldcolumn = "0"
  end
end

---Create an autocommand to launch Telescope file browser when opening dirs.
---This is a copy from the plugin local function `hijack_netrw` (without the
---netrw part) that allows lazy-loading of the plugin without requiring
---Telescope at startup.
function Custom.attach_telescope_file_browser()
  local previous_buffer_name
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("UserFileBrowser", { clear = true }),
    pattern = "*",
    callback = function()
      vim.schedule(function()
        local buffer_name = vim.api.nvim_buf_get_name(0)
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
        vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
        require("telescope").extensions.file_browser.file_browser({
          cwd = vim.fn.expand("%:p:h"),
        })
      end)
    end,
    desc = "telescope-file-browser.nvim replacement for netrw",
  })
end

---Create a buffer for taking notes into a scratch buffer
--- **Usage:** `Scratch`
function Custom.set_create_scratch_buffers()
  vim.api.nvim_create_user_command("Scratch", function()
    vim.cmd("bel 10new")
    local buf = vim.api.nvim_get_current_buf()
    local opts = {
      bufhidden = "hide",
      buftype = "nofile",
      filetype = "scratch",
      modifiable = true,
      swapfile = false,
    }
    for key, value in pairs(opts) do
      vim.api.nvim_set_option_value(key, value, { buf = buf })
    end
  end, { desc = "Create a scratch buffer" })
end

---Custom lualine section that integrates Harpoon marks
---@return string
function Custom.lualine_harpoon()
  local hp_list = require("harpoon"):list()
  local total_marks = hp_list:length()
  if total_marks == 0 then
    return ""
  end

  local nvim_mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  local hp_keymap = { "j", "k", "l", "h" }
  local hl_normal = nvim_mode == "n" and "%#lualine_b_normal#"
    or nvim_mode == "i" and "%#lualine_b_insert#"
    or nvim_mode == "c" and "%#lualine_b_command#"
    or "%#lualine_b_visual#"
  local hl_selected = string.find("vV", nvim_mode)
      and "%#lualine_transitional_lualine_a_visual_to_lualine_b_visual#"
    or "%#lualine_b_diagnostics_warn_normal#"

  local full_name = vim.api.nvim_buf_get_name(0)
  local buffer_name = vim.fn.expand("%")
  local output = { " " } -- 󰀱

  for index = 1, total_marks <= 4 and total_marks or 4 do
    local mark = hp_list.items[index].value
    if mark == buffer_name or mark == full_name then
      table.insert(output, hl_selected)
      table.insert(output, hp_keymap[index])
      table.insert(output, hl_normal)
    else
      table.insert(output, hp_keymap[index])
    end
  end

  return table.concat(output, "")
end

return Custom
