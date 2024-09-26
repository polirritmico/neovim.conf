---Functions for text-based writing tasks beyond code.
---@class UtilsWriting
local Writing = {}

local api = vim.api
local ts = vim.treesitter

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

---Generate Lorem ipsum text through
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

-------------------------------------------------------------------------------

---Create a location-list TOC from the current file TS tree
---@param lang string
---@param ts_query string
---@param text_process fun(raw_text: string, node: TSNode): string
function Writing.generate_toc_loclist(lang, ts_query, text_process)
  local bufnr = api.nvim_get_current_buf()
  if api.nvim_get_option_value("filetype", { buf = bufnr }) == "qf" then
    return
  end

  local ts_parser = ts.get_parser(bufnr)
  local ts_tree = assert(ts_parser:parse()[1])
  if lang ~= ts_parser:lang() then
    vim.notify("Bad parser: " .. lang .. " " .. ts_parser:lang(), vim.log.levels.WARN)
    return
  end

  ---@type vim.treesitter.Query
  local parsed_query = ts.query.parse(lang, ts_query)

  local doc_sections = {}
  local filename_len = #string.gsub(vim.fn.expand("%"), vim.fn.getcwd(), "")
  for _, node in parsed_query:iter_captures(ts_tree:root(), bufnr) do
    local linenr = node:range() + 1
    local raw_text = ts.get_node_text(node, bufnr)
    local mark_col = filename_len + #tostring(linenr) + 3 -- 2 bars + 1 space

    local text = text_process(raw_text, node)
    local count = select(2, text:gsub("#", ""))
    table.insert(doc_sections, {
      -- for setloclist:
      bufnr = bufnr,
      lnum = linenr,
      text = text,
      -- for highlights:
      hl = "@markup.heading." .. count .. ".marker",
      coll = mark_col,
      colr = mark_col + count,
    })
  end

  local winnr = api.nvim_get_current_win()
  vim.fn.setloclist(winnr, doc_sections)
  vim.fn.setloclist(winnr, {}, "a", { title = lang:upper() .. " TOC" })
  vim.cmd("lopen")

  bufnr = api.nvim_win_get_buf(0)
  api.nvim_set_option_value("modifiable", true, { buf = bufnr })
  ts.get_parser(bufnr, "markdown")
  for line, sec in pairs(doc_sections) do
    api.nvim_buf_add_highlight(bufnr, -1, sec.hl, line - 1, sec.coll, sec.colr)
  end
  api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.cmd("lclose")
end

---Create a location-list from the current file TOC
function Writing.loclist_toc_markdown()
  local ts_query = [[(section (atx_heading) @toc) (section (setext_heading) @toc)]]
  Writing.generate_toc_loclist("markdown", ts_query, function(raw)
    local text = raw:match("^[^\n]*") ---@type string
    -- handle markdown alternative headers:
    if raw:sub(1, 1) ~= "#" then
      text = ((vim.split(raw, "\n")[2]):sub(1, 1) == "=" and "# " or "## ") .. text
    end
    return text
  end)
end

---Create a location-list from the current file TOC
function Writing.loclist_toc_latex()
  local ts_query = [[
    (chapter (curly_group (text) @header))
    (section (curly_group (text) @header))
    (subsection (curly_group (text) @header))
    (subsubsection (curly_group (text) @header))
    (paragraph (curly_group (text) @header))
  ]]

  Writing.generate_toc_loclist("latex", ts_query, function(raw, node)
    local type = node:parent():parent():type()
    if type == "chapter" or type == "section" then
      return "# " .. raw
    elseif type == "subsection" then
      return "## " .. raw
    elseif type == "subsubsection" then
      return "### " .. raw
    elseif type == "paragraph" then
      return "#### " .. raw
    elseif type == "subparagraph" then
      return "##### " .. raw
    end
    return raw
  end)
end

---Helper function to move to the next/previous loclist entry. If the current
---window does not have an attached loclist, it creates one.
---@param direction string "next" or "prev"
function Writing.toc_move(direction)
  local winnr = api.nvim_get_current_win()
  if vim.tbl_isempty(vim.fn.getloclist(winnr)) then
    Writing["loclist_toc_" .. vim.bo.filetype]()
  end
  vim.cmd("l" .. direction)
end

---This function sets a user_command that generates a Table of Contents for the
---current file, based on the treesitter header nodes, and adds it into the
---buffer at the current cursor position with the appropriate markdown format.
---
---The inner-level could be passed, e.g. `:TOC 2` would add only h1 and h2.
---@param cmd? string Name of the command to execute from the command-line.
---@param desc? string Description to pass into the command generator
function Writing.set_md_toc_generator(cmd, desc)
  cmd = cmd or "TOC"
  desc = desc or "Write TOC at the current cursor position. args: `depth_level` integer"

  ---@param ctx? table
  local function write_toc(ctx)
    local bufnr = ctx and ctx.bufnr or api.nvim_get_current_buf()
    local max_depth = (ctx and ctx.args) and tonumber(ctx.args) or nil

    local ts_query = [[(section (atx_heading) @toc) (section (setext_heading) @toc)]]
    local ts_parser = ts.get_parser(bufnr)
    local ts_tree = assert(ts_parser:parse()[1])
    if ts_parser:lang() ~= "markdown" then
      vim.notify("Not markdown", vim.log.levels.WARN)
      return
    end
    ---@type vim.treesitter.Query
    local parsed_query = ts.query.parse("markdown", ts_query)

    local doc_sections = { "## TOC" }
    for _, node in parsed_query:iter_captures(ts_tree:root(), bufnr) do
      -- `- [Title text](#title-text)`
      local raw = ts.get_node_text(node, bufnr)
      local text = raw:match("^[^\n]*") ---@type string
      if raw:sub(1, 1) ~= "#" then
        text = ((vim.split(raw, "\n")[2]):sub(1, 1) == "=" and "# " or "## ") .. text
      end
      local level = select(2, text:gsub("#", ""))
      if not max_depth or level <= max_depth then
        local tag_level = string.rep("  ", level - 2)
        local header = text:gsub("^#+%s*", "")
        local anchor = header:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower()

        local entry = string.format("%s- [%s](#%s)", tag_level, header, anchor)
        doc_sections[#doc_sections + 1] = entry
      end
    end
    if #doc_sections < 2 then
      return
    end

    -- Remove h1 header and add empty line at bottom
    doc_sections[2] = ""
    doc_sections[#doc_sections + 1] = ""

    -- Write the TOC into the file
    local cursor = api.nvim_win_get_cursor(api.nvim_get_current_win())
    local row = cursor[1]
    api.nvim_buf_set_lines(bufnr, row, row, false, doc_sections)
  end

  api.nvim_create_user_command(cmd, write_toc, { nargs = "?", desc = desc })
end

return Writing
