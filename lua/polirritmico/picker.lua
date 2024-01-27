local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- local colors = function(opts)
--   opts = opts or {}
--   pickers
--     .new(opts, {
--       prompt_title = "Colors",
--       finder = finders.new_table({
--         -- results = { "red", "green", "blue" },
--         results = {
--           { "red", "ff0000" },
--           { "green", "#00ff00" },
--           { "blue", "#0000ff" },
--         },
--         entry_maker = function(entry)
--           return {
--             value = entry,
--             display = entry[1],
--             ordinal = entry[1],
--           }
--         end,
--       }),
--       sorter = conf.generic_sorter(opts),
--       attach_mappings = function(prompt_bufnr, map)
--         actions.select_default:replace(function()
--           actions.close(prompt_bufnr)
--           local selection = action_state.get_selected_entry()
--           P(selection)
--           -- vim.api.nvim_put({ selection[1] }, "", false, true)
--           vim.api.nvim_put({ selection["value"][2] }, "", false, true)
--         end)
--         return true
--       end,
--     })
--     :find()
-- end
-- local theme = require("telescope.themes").get_dropdown({})
-- colors(theme)

local function get_lazy_plugins_from_spec()
  local lazy_plugins = require("lazy.core.config").spec.plugins
  local plugins = {}
  for _, spec in pairs(lazy_plugins) do
    local author_and_plugin_name = spec[1]
    local config_file = spec["dir"]
    table.insert(plugins, { author_and_plugin_name, config_file })
    -- TODO: Handle multiple spec files of the same plugin. Check plugins[plugin].super
  end
  P(plugins)
end

get_lazy_plugins_from_spec()

local plugins_picker = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Plugins in Lazy spec",
      finder = finders.new_table(get_lazy_plugins_from_spec),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

-- plugins_picker(require("telescope.themes").get_dropdown({}))
