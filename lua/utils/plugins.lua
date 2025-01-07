---Helper functions used to configure or customize plugins settings.
---@class UtilsPlugins
local Plugins = {}

local fmt = string.format

---@module "blink.cmp"
---@return blink.cmp.SnippetsConfig
function Plugins.blink_luasnip_cfg()
  return {
    expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
    jump = function(direction) require("luasnip").jump(direction) end,
    active = function(filter)
      if filter and filter.direction then
        return require("luasnip").jumpable(filter.direction)
      end
      return require("luasnip").in_snippet()
    end,
  }
end

---Returns a function to expand the current luasnip snippet
function Plugins.blink_luasnip_expand()
  return function(cmp)
    vim.schedule(function()
      local ls = require("luasnip")
      if ls.expandable() then
        ls.expand()
      else
        cmp.select_and_accept()
      end
    end)
  end
end

---Enable or disable _conform.nvim_ `autoformat-on-save` functionality (globally).
function Plugins.conform_toggle()
  vim.g.disable_autoformat = not (vim.g.disable_autoformat == true)
  local msg = "Conform: %sabled autoformat-on-save."
  vim.notify(fmt(msg, vim.g.disable_autoformat and "Dis" or "En"))
end

---Enable or disable _conform.nvim_ `autoformat-on-save` functionality (locally).
function Plugins.conform_toggle_local()
  vim.b.disable_autoformat = not (vim.b.disable_autoformat == true)
  local msg = "Conform: %sabled autoformat-on-save on the current buffer."
  vim.notify(fmt(msg, vim.b.disable_autoformat and "Dis" or "En"))
end

function Plugins.dap_set_custom_marks()
  local breakpoint_hl = "DiagnosticInfo"
  local normal_hl = "Normal"

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = breakpoint_hl, numhl = breakpoint_hl }
  )
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "󰗦", texthl = breakpoint_hl, numhl = breakpoint_hl }
  )
  vim.fn.sign_define(
    "DapStopped",
    { text = "→", texthl = normal_hl, numhl = normal_hl }
  )
end

---Config TypeScript dap adapter
---@param dap dap.Session
function Plugins.dap_config_typescript(dap)
  local js_dap_path = require("mason-registry")
    .get_package("js-debug-adapter")
    :get_install_path() .. "/js-debug/src/dapDebugServer.js"

  if not dap.adapters["pwa-node"] then
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_dap_path, "${port}" },
      },
    }
  end

  if not dap.adapters["node"] then
    dap.adapters["node"] = function(cb, config)
      if config.type == "node" then
        config.type = "pwa-node"
      end
      local nativeAdapter = dap.adapters["pwa-node"]
      if type(nativeAdapter) == "function" then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end

  local js_filetypes = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
  }
  local vscode = require("dap.ext.vscode")
  vscode.type_to_filetypes["node"] = js_filetypes
  vscode.type_to_filetypes["pwa-node"] = js_filetypes

  for _, lang in ipairs(js_filetypes) do
    if not dap.configurations[lang] then
      dap.configurations[lang] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach",
        --   processId = require("dap.utils").pick_process,
        --   cwd = "${workspaceFolder}",
        -- },
      }
    end
  end
end

---Return a custom lualine tabline section that integrates Harpoon marks.
function Plugins.lualine_harpoon()
  local hp_keys = { "j", "k", "l", "h" }
  local prev_file, prev_output, prev_mode, prev_count, hp

  return function()
    hp = hp or require("harpoon")
    local hp_list = hp:list()
    local total_marks = hp_list:length()
    if total_marks == 0 then
      return ""
    end

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_file_exp = vim.fn.expand("%")
    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    -- PERF: Same state returns the previous output
    if
      mode == prev_mode
      and (current_file == prev_file or current_file_exp == prev_file)
      and prev_count == total_marks
    then
      return prev_output
    end

    local hl_normal = mode == "n" and "%#lualine_b_normal#"
      or mode == "i" and "%#lualine_b_insert#"
      or mode == "c" and "%#lualine_b_command#"
      or "%#lualine_b_visual#"
    local hl_selected = ("v" == mode or "V" == mode or "" == mode)
        and "%#lualine_transitional_lualine_a_visual_to_lualine_b_visual#"
      or "%#lualine_b_diagnostics_warn_normal#"

    local output = " " -- 󰀱
    for index = 1, total_marks <= 4 and total_marks or 4 do
      local marked_file = hp_list.items[index].value
      -- FIXME: Sometimes the buffname is the full path and others the symlink...
      if marked_file == current_file_exp or marked_file == current_file then
        output = output .. hl_selected .. hp_keys[index] .. hl_normal
      else
        output = output .. hp_keys[index]
      end
    end

    prev_count = total_marks
    prev_file = current_file
    prev_mode = mode
    prev_output = output

    return output
  end
end

---A custom Telescope picker to use MiniSessions actions
function Plugins.mini_sessions_manager()
  local mini_sessions = require("mini.sessions")
  local tlstate = require("telescope.actions.state")
  local close = require("telescope.actions").close
  local theme = require("telescope.themes").get_dropdown

  local opts = {}
  local open_picker = function() require("telescope.builtin").find_files(theme(opts)) end

  ---@return string?, string?
  local function get_user_input()
    local selected = tlstate.get_selected_entry()
    local input_text = tlstate.get_current_line()
    selected = selected and selected[1] or nil
    input_text = input_text ~= "" and input_text or nil
    return selected, input_text
  end

  ---@param filename string?
  local function write_session(bufnr, filename)
    if not filename then
      local selected, input_text = get_user_input()
      filename = selected or input_text
    end

    if not filename or filename == "" then
      vim.notify("write_session: Empty or nil filename", vim.log.levels.WARN)
    elseif vim.fn.findfile(vim.fn.expand(filename)) == "" then
      close(bufnr)
      mini_sessions.write(filename)
    elseif
      vim.fn.input(fmt("Overwrite session %s? [y/n]: ", filename)):lower() == "y"
    then
      close(bufnr)
      mini_sessions.write(filename)
    else
      vim.notify("Aborted", vim.log.levels.INFO)
    end
  end

  local function delete_session(bufnr)
    local selected, _ = get_user_input()
    if not selected then
      vim.notify("delete_session: Empty selection", vim.log.levels.WARN)
    elseif vim.fn.input(fmt("Delete session %s? [y/n]: ", selected)):lower() == "y" then
      mini_sessions.delete(selected, { force = true })
      close(bufnr)
      open_picker()
    else
      vim.notify("Aborted", vim.log.levels.INFO)
    end
  end

  local function read_or_write_session(bufnr)
    local selected, input_text = get_user_input()

    if not selected and not input_text then
      vim.notify("Empty selection and input text", vim.log.levels.INFO)
    elseif not selected and input_text then
      write_session(bufnr, input_text)
    elseif selected and not input_text then
      mini_sessions.read(selected)
    elseif selected == input_text then
      mini_sessions.read(selected)
    else -- user must decide
      local msg = fmt(
        "Type 'w' to write or press '<CR>' to open (selected '%s'): ",
        selected,
        input_text
      )
      local user_input = vim.fn.input(msg):lower()

      if user_input == "w" then
        write_session(bufnr, input_text)
      else
        mini_sessions.read(selected)
      end
    end
  end

  -- Build the picker
  opts = {
    cwd = mini_sessions.config.directory,
    results_title = "Sessions Manager",
    prompt_title = "<CR>:Open  <C-s>:Save  <C-d>:Delete",
    previewer = false,
    layout_config = { height = { 0.6, max = 21 }, width = { 0.99, max = 65 } },
    attach_mappings = function(_, map)
      map("i", "<CR>", read_or_write_session)
      map("i", "<C-s>", write_session)
      map("i", "<C-d>", delete_session)
      map("i", "<ESC>", close)
      map("i", "<C-n>", "move_selection_next")
      map("i", "<C-p>", "move_selection_previous")
      map("i", "<C-w>", function() vim.api.nvim_input("<C-S-w>") end)
      return false -- false to only use attached mappings
    end,
  }
  open_picker()
end

---Install pylsp-rope inside the pylsp venv so it can enable rope capabilities
function Plugins.mason_install_pylsp_rope()
  local mr = require("mason-registry")

  local pylsp = mr.get_package("python-lsp-server")
  local pylsp_path = pylsp:get_install_path()
  mr:on(
    "package:install:success",
    function(_)
      vim.system(
        { "bash", "-c", "source venv/bin/activate && pip install pylsp-rope" },
        { cwd = pylsp_path }
      )
    end
  )
end

---Oil.nvim: Set a configuration key for the confirm changes prompt.
---@param keys string|string[] Confirmation key.
function Plugins.oil_confirmation_key(keys)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil_preview",
    callback = function(ctx)
      if type(keys) ~= "table" then
        keys = { keys }
      end
      for _, key in pairs(keys) do
        vim.keymap.set("n", key, "Y", { buffer = ctx.buf, remap = true, nowait = true })
      end
    end,
  })
end

---Telescope action helper to pass the current matches into another telescope
---instance. `live_grep` by default. If is a `live_grep`, then pass the matches
---into a `find_files` picker.
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_narrow_matches(bufnr)
  local builtin = require("telescope.builtin")
  local actions_state = require("telescope.actions.state")
  local map_entries = require("telescope.actions.utils").map_entries
  local matches = {}

  if actions_state.get_current_picker(bufnr).prompt_title ~= "Live Grep" then
    map_entries(bufnr, function(entry) table.insert(matches, entry[0] or entry[1]) end)
    builtin.live_grep({ search_dirs = matches })
  else
    map_entries(bufnr, function(entry) table.insert(matches, entry.filename) end)
    builtin.find_files({ search_dirs = matches })
  end
end

---Telescope action helper to open a qflist with all current matches and open
---the first entry.
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_open_and_fill_qflist(bufnr)
  local actions = require("telescope.actions")
  actions.send_to_qflist(bufnr)
  actions.open_qflist(bufnr)
  vim.api.nvim_input("<CR>")
end

---Telescope action helper to open single or multiple files
---@param bufnr integer Telescope prompt buffer number
function Plugins.telescope_open_single_or_multi(bufnr)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local single_selection = actions_state.get_selected_entry()
  local multi_selection = actions_state.get_current_picker(bufnr):get_multi_selection()
  if not vim.tbl_isempty(multi_selection) then
    actions.close(bufnr)
    for _, file in pairs(multi_selection) do
      if file.path ~= nil then
        vim.cmd(fmt("edit %s", file.path))
      end
    end
    vim.cmd(fmt("edit %s", single_selection.path))
  else
    actions.select_default(bufnr)
  end
end

---Simple Telescope picker to select spell suggestions
function Plugins.telescope_spell_suggest()
  local theme = require("telescope.themes").get_dropdown
  require("telescope.builtin").spell_suggest(theme())
end

return Plugins
