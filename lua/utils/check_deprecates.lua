local M = {}

---@class Match
---@field file string
---@field linenr string
---@field code string

---@param filepath string
---@return string data
function M.read_file(filepath)
  local fd = assert(io.open(filepath, "r"))
  local data = fd:read("*a")
  fd:close()
  return data
end

---@param data any
---@param filepath string
function M.write_file(data, filepath)
  local fd = assert(io.open(filepath, "w+"))
  fd:write(data)
  fd:close()
end

---@param raw_data string
---@return table<string>
function M.split_multiline_string(raw_data)
  local data = {}
  for line in raw_data:gmatch("[^\r\n]+") do
    table.insert(data, line)
  end
  return data
end

---@param matches_raw string
---@return table<Match>
function M.parse_matches(matches_raw, path)
  local matches = {}
  local matches_lines = M.split_multiline_string(matches_raw)
  local relative_path_index = path:len() + 2

  for _, line_raw in pairs(matches_lines) do
    local row = {}
    for section in string.gmatch(line_raw, "[^:]+") do
      table.insert(row, section)
    end

    table.insert(matches, {
      file = row[1]:sub(relative_path_index),
      linenr = row[2],
      code = row[3]:match("^%s*(.*)"),
    })
  end

  return matches
end

---@param search_strings table<string>
---@param path string
---@return table<string, table<Match>> matches
function M.search_matches(search_strings, path)
  local grep_command = [[grep -n -r --include="*.lua" "%s" "%s"]]
  local matches = {}
  for _, search_str in pairs(search_strings) do
    local cmd_output = vim.fn.system(string.format(grep_command, search_str, path))
    if cmd_output ~= "" then
      matches[search_str] = M.parse_matches(cmd_output, path)
    end
  end
  return matches
end

---@param matches table<string, table<Match>>
---@param path_project
---@return string
function M.create_table_from_matches(matches, path_project)
  local head = string.format(
    [[
# Deprecated functions in `%s`

| Filepath:line | Deprecated | Code |
| ------------- | ---------- | ---- |
  ]],
    path_project:match("^.+/(.+)$")
  )
  local rows = {}
  for deprecated, match in pairs(matches) do
    for _, line_data in pairs(match) do
      local line = string.format(
        [[| %s:%s | %s | %s |]],
        line_data.file,
        line_data.linenr,
        deprecated,
        line_data.code
      )
      table.insert(rows, line)
    end
  end
  local body = table.concat(rows, "\n")
  return string.format("%s%s", head, body)
end

function M.prettify_output_file(filepath)
  local ok, mason = pcall(require, "mason-registry")
  if not ok or not mason.is_installed("prettier") then
    return
  end
  local prettier = mason.get_package("prettier"):get_install_path()
    .. "/node_modules/prettier/bin/prettier.cjs"

  local cmd = string.format("%s -w %s", prettier, filepath)
  vim.fn.system(cmd)
end

---@param path_deprecations_list string
---@param path_project string
---@param output_file string
function M.run(path_deprecations_list, path_project, output_file)
  path_deprecations_list = vim.fn.expand(path_deprecations_list)
  path_project = vim.fn.expand(path_project)
  output_file = vim.fn.expand(output_file)

  local deprecations_list_raw = M.read_file(path_deprecations_list)
  local deprecations = M.split_multiline_string(deprecations_list_raw)
  local matches = M.search_matches(deprecations, path_project)

  local formated_table = M.create_table_from_matches(matches, path_project)
  M.write_file(formated_table, output_file)
  M.prettify_output_file(output_file)

  vim.notify("Done")
end
