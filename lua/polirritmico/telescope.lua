local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")

local example = function(opts)
    local registers_table = { '"', "-", "#", "=", "/", "*", "+", ":", ".", "%" }
    for i = 0, 9 do
        table.insert(registers_table, tostring(i))
    end
    for i = 65, 90 do
        table.insert(registers_table, string.char(i))
    end

    opts = opts or {}
    pickers.new(opts, {
        promtp_title = "Registers",
        finder = finders.new_table({
            results = registers_table,
            entry_maker = opts.entry_maker or make_entry.gen_from_registers(opts),
        }),
        previewer = previewers.new_buffer_previewer({
            title = "Buffer preview",
            define_preview = function(self, entry, status)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
                    vim.fn.getreg(entry, 1)
                })
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_, map)
            actions.select_default:replace(actions.paste_register)
            map({ "i", "n" }, "<C-e>", actions.edit_register)
            return true
        end,
    }):find()
end

example()
