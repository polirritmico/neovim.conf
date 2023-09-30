-- Telescope
if not Check_loaded_plugin("telescope.nvim") then return end

local ignore_filetypes_list = {
    "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.JPG", "%.PNG", "%.webp",
    "%.WEBP", "%.mp3", "%.MP3", "%.pdf", "%.PDF", "%.odt", "%.ODT", "%.ico", "%.ICO",
}

local telescope = require("telescope")
telescope.setup({
    defaults = {
        file_ignore_patterns = ignore_filetypes_list,
        layout_strategy = "flex",
        layout_config = {
            flex = { flip_columns = 120 },
            horizontal = { preview_width = { 0.6, max = 100, min = 30 } }
        },
        path_display = { "truncate" },
        prompt_prefix = "   ",
        selection_caret = " 󰄾  ",
        -- FIX https://github.com/nvim-telescope/telescope.nvim/issues/559
        -- But have troubles when creating files/dirs with file browser.
        -- mappings = {
        --     i = {["<CR>"] = function()
        --         vim.cmd [[:stopinsert]]
        --         vim.cmd [[call feedkeys("\<CR>")]]
        --     end},
        -- },
    },
    extensions = {
        ["fzf"] = { fuzzy = true, override_generic_sorter = true, },
        file_browser = { hijack_netrw = true, },
        heading = {
            treesitter = true,
            picker_opts = {
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                layout_config = {
                    preview_cutoff = 20,
                    preview_width = 0.7,
                },
            },
        }
    },
})

-- Cargar extension file_browser
telescope.load_extension("file_browser")
telescope.load_extension("heading")

-- Mappings
Keymap({ "n", "v" }, "<leader>ff", "<CMD>Telescope find_files<CR>", "Telescope: Find files")
Keymap({ "n", "v" }, "<leader>fe", "<CMD>Telescope file_browser<CR>", "Telescope: Find files in file_browser")
Keymap({ "n", "v" }, "<leader>fg", "<CMD>Telescope live_grep<CR>", "Telescope: Find grep")
Keymap({ "n", "v" }, "<leader>fb", "<CMD>Telescope buffers<CR>", "Telescope: Find buffers")
Keymap({ "n", "v" }, "<leader>fr", "<CMD>Telescope oldfiles<CR>", "Telescope: Find recents")
Keymap({ "n", "v" }, "<leader>fh", "<CMD>Telescope help_tags<CR>", "Telescope: Find help")
Keymap({ "x" }, "<leader>fs", "<CMD>lua require'telescope.builtin'.grep_string{}<CR>", "Telescope: Find selected string")
Keymap({ "n", "v" }, "<leader>fF", "<CMD>lua require'telescope.builtin'.find_files{cwd = vim.fn.expand('%:p:h'), hidden = true}<CR>", "Telescope: Browse mode in nvim path")
Keymap({ "n", "v" }, "<leader>fE", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>", "Telescope: Browse mode in buffer path")
Keymap({"n", "v"}, "<leader>th", "<CMD>Telescope heading<CR>", "Telescope: Get headers")
