---Helper functions for text-based writing tasks beyond code.
---@class UtilsWriting
local Writing = {}

local api = vim.api

-- NOTE: To create the compiled dict from dic and aff files use:
-- `:mkspell output input`. e.g. For `es_CL.aff` and `es_CL.dic` files, the
-- command should be: `:mkspell es es_CL` (in config/spell dir).

---Enables spell checkers for the specified language.
---@param lang string Language ISO-like string. _E.g. es_CL, es, en, etc._
function Writing.dict_on(lang)
  if api.nvim_get_option_value("spelllang", {}) ~= lang then
    vim.opt.spelllang = lang
  end
  vim.opt.spell = true
  vim.notify("Spell enabled " .. lang)
end

---Disable spell checkers and unset the `spelllang` variable.
function Writing.dict_off()
  if not api.nvim_get_option_value("spell", {}) then
    return
  end
  vim.opt.spelllang = "en"
  vim.opt.spell = false
  vim.notify("Spell disabled")
end

---This function enables the **TwoColumns** mode, which splits the current
---buffer into two synced column-like windows, resembling newspapers articles.
---- **Usage**: `:TwoColumns`. To end just close one of the windows.
function Writing.set_two_columns_mode()
  vim.cmd([[
    command! TwoColumns exe "normal zR" | set noscrollbind | vsplit
      \ | set scrollbind | wincmd w | exe "normal \<c-f>" | set scrollbind | wincmd p
  ]])
end

---Generate Lorem ipsum text through the loripsum.net API
---@param paragraphs integer
function Writing.lorem(paragraphs)
  paragraphs = paragraphs or vim.v.count > 0 and vim.v.count or 2
  local opts = "/medium/prude/plaintext"
  local url = "https://loripsum.net/api/"
  local curl_cmd = string.format("curl %s%s%s 2>/dev/null", url, paragraphs, opts)

  vim.notify("Fetching text from the 'https://lorpsum.net' api...")

  local content = vim.fn.systemlist(curl_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Curl failed with code " .. vim.v.shell_error, vim.log.levels.ERROR)
  end
  content[#content] = nil

  local first_line = api.nvim_buf_line_count(0)
  api.nvim_buf_set_lines(0, first_line - 1, first_line - 1, false, content)
  local last_line = first_line + #content

  vim.cmd(string.format("normal! %dGv%dGgw", first_line, last_line))
  vim.cmd("stopinsert")
end

---Move the cursor to the next link in the line
---Loops over multiple links in the same line.
function Writing.next_link()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local curline, curcol = unpack(vim.api.nvim_win_get_cursor(winnr)) -- line 1-idx, col 0-idx

  local function set_cursor_pos(node)
    if node then
      local _, node_col = node:range()
      vim.api.nvim_win_set_cursor(winnr, { curline, node_col })
    end
  end

  local lang = "markdown_inline"
  local capture = "markup.link"
  local node_type = "link_destination"

  local ts_parser = vim.treesitter.get_parser(bufnr, lang)
  local query = assert(vim.treesitter.query.get(lang, "highlights"))
  assert(ts_parser, "Missing treesitter buffer parser")
  local root = ts_parser:parse()[1]:root()

  local left_node
  for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[id] == capture and node:type() == node_type then
      local node_line, node_col = node:range()
      if node_line + 1 == curline then -- node_line 0-idx
        if not left_node then
          left_node = node
        end
        if node_col > curcol then
          set_cursor_pos(node)
          return
        end
      end
    end
  end
  set_cursor_pos(left_node)
end

function Writing.table_in_clipboard_to_markdown()
  local clipboard_content = vim.fn.getreg("+")

  local markdown_tbl = {}
  local split_by_newline_pattern = "[^\n]+"
  local match_text_between_bars = "[^|]+"

  local is_header = true
  for line in clipboard_content:gmatch(split_by_newline_pattern) do
    line = string.format("| %s |", line:gsub("\t", " | "))
    markdown_tbl[#markdown_tbl + 1] = line
    if is_header then
      local separator = line:gsub(match_text_between_bars, "---")
      markdown_tbl[#markdown_tbl + 1] = separator
      is_header = false
    end
  end

  api.nvim_put(markdown_tbl, "l", true, true)
end

return Writing
