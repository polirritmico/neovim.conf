-- Telescope
 local plugin_name = "telescope.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "venv",
            "__pycache__",
            ".xlsx",
        }
    },
    extensions = {
        ["fzf"] = {
            fuzzy = true,
            override_generic_sorter = true,
        }
    },
})

require("telescope").load_extension "file_browser"

-- Mappings
local function map(m, k, v)
    vim.keymap.set(m, k, v, {silent = true})
end

map({"n", "v"}, "<leader>ff", "<CMD>Telescope find_files<CR>")  -- find files
map({"n", "v"}, "<leader>fE", "<CMD>Telescope file_browser<CR>")  -- find files
map({"n", "v"}, "<leader>fg", "<CMD>Telescope live_grep<CR>")   -- find grep
map({"n", "v"}, "<leader>fb", "<CMD>Telescope buffers<CR>")     -- find buffers
map({"n", "v"}, "<leader>fr", "<CMD>Telescope oldfiles<CR>")    -- find recents
map({"n", "v"}, "<leader>fh", "<CMD>Telescope help_tags<CR>")   -- find help
map({"n", "v"}, "<leader>fs",                                   -- find selected
    "<CMD>lua require'telescope.builtin'.grep_string{}<CR>")
map({"n", "v"}, "<leader>fF",                                   -- ff from current buffer location
    "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>")

