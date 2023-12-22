--- Telescope: Searches with fzf

return {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "crispgm/telescope-heading.nvim",
        -- "debugloop/telescope-undo.nvim",
    },
    config = function()
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
                mappings = {i = {["<C-h>"] = "which_key"}}, -- toggle keymaps help
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
                },
            },
        })

        -- Extensions
        telescope.load_extension("file_browser")
        telescope.load_extension("heading")
    end,
    keys = {
        {"<leader>ff", "<CMD>Telescope find_files<CR>", { "n", "v" },
            desc = "Telescope: Find files", silent = true},
        {"<leader>fe", "<CMD>Telescope file_browser<CR>", { "n", "v" },
            desc = "Telescope: Find files in file_browser", silent = true},
        {"<leader>fg", "<CMD>Telescope live_grep<CR>", { "n", "v" },
            desc = "Telescope: Find grep", silent = true},
        {"<leader>fb", "<CMD>Telescope buffers<CR>", { "n", "v" },
            desc = "Telescope: Find buffers", silent = true},
        {"<leader>fr", "<CMD>Telescope registers<CR>", { "n", "v" },
            desc = "Telescope: Copy a register", silent = true},
        {"<leader>fR", "<CMD>Telescope oldfiles<CR>", { "n", "v" },
            desc = "Telescope: Find recents", silent = true},
        {"<leader>fh", "<CMD>Telescope help_tags<CR>", { "n", "v" },
            desc = "Telescope: Find help", silent = true},
        {"<leader>fs", "<CMD>lua require'telescope.builtin'.grep_string{}<CR>", { "x" },
            desc = "Telescope: Find selected string", silent = true},
        {"<leader>fF", "<CMD>lua require'telescope.builtin'.find_files{cwd = vim.fn.expand('%:p:h'), hidden = true}<CR>",
            { "n", "v" }, desc = "Telescope: Browse mode in nvim path", silent = true},
        {"<leader>fE", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
            { "n", "v" }, desc = "Telescope: Browse mode in buffer path", silent = true},
        {"<leader>fH", "<CMD>Telescope heading<CR>", { "n", "v" },
            desc = "Telescope: Get headers", silent = true},
    }
}
