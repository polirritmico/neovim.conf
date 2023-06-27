-- Telescope
local plugin_name = "telescope.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local ignore_filetypes_list = {
    "venv", "__pycache__", ".xlsx", ".jpg", ".png", ".JPG", ".PNG", ".webp",
    ".WEBP", ".mp3", ".MP3", ".pdf", ".PDF", ".odt", ".ODT"
}

require("telescope").setup({
    defaults = { file_ignore_patterns = ignore_filetypes_list },
    extensions = { ["fzf"] = { fuzzy = true, override_generic_sorter = true, } },
})

-- Mappings
local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map({ "n", "v" }, "<leader>ff", "<CMD>Telescope find_files<CR>")   -- find files
map({ "n", "v" }, "<leader>fE", "<CMD>Telescope file_browser<CR>") -- find files
map({ "n", "v" }, "<leader>fg", "<CMD>Telescope live_grep<CR>")    -- find grep
map({ "n", "v" }, "<leader>fb", "<CMD>Telescope buffers<CR>")      -- find buffers
map({ "n", "v" }, "<leader>fr", "<CMD>Telescope oldfiles<CR>")     -- find recents
map({ "n", "v" }, "<leader>fh", "<CMD>Telescope help_tags<CR>")    -- find help
-- find selected:
map({ "n", "v" }, "<leader>fs", "<CMD>lua require'telescope.builtin'.grep_string{}<CR>")
-- browse files from current buffer location
map({ "n", "v" }, "<leader>fF", "<CMD>lua require'telescope.builtin'.find_files{cwd = vim.fn.expand('%:p:h')}<CR>")
