-- Telescope
if not Check_loaded_plugin("telescope.nvim") then return end

local ignore_filetypes_list = {
    "venv", "__pycache__", ".xlsx", ".jpg", ".png", ".JPG", ".PNG", ".webp",
    ".WEBP", ".mp3", ".MP3", ".pdf", ".PDF", ".odt", ".ODT"
}

require("telescope").setup({
    defaults = {
        file_ignore_patterns = ignore_filetypes_list,
        prompt_prefix = "   ",
        selection_caret = " 󰄾  ",
    },
    extensions = {
        ["fzf"] = { fuzzy = true, override_generic_sorter = true, },
        file_browser = { hijack_netrw = true, },
    },
})

-- Cargar extension file_browser
require("telescope").load_extension("file_browser")

-- Mappings
Keymap({ "n", "v" }, "<leader>ff", "<CMD>Telescope find_files<CR>", "Find files")
Keymap({ "n", "v" }, "<leader>fe", "<CMD>Telescope file_browser<CR>", "Find files in file_browser")
Keymap({ "n", "v" }, "<leader>fg", "<CMD>Telescope live_grep<CR>", "Find grep")
Keymap({ "n", "v" }, "<leader>fb", "<CMD>Telescope buffers<CR>", "Find buffers")
Keymap({ "n", "v" }, "<leader>fr", "<CMD>Telescope oldfiles<CR>", "Find recents")
Keymap({ "n", "v" }, "<leader>fh", "<CMD>Telescope help_tags<CR>", "Find help")
-- find selected:
Keymap({ "x" }, "<leader>fs", "<CMD>lua require'telescope.builtin'.grep_string{}<CR>", "find selected string")
-- browse files from current buffer location
Keymap({ "n", "v" }, "<leader>fF", "<CMD>lua require'telescope.builtin'.find_files{cwd = vim.fn.expand('%:p:h'), hidden = true}<CR>", "Browse mode in nvim path")
Keymap({ "n", "v" }, "<leader>fE", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>", "Browse mode in buffer path")
