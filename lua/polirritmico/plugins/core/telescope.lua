--- Telescope: Searches with fzf

return {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "crispgm/telescope-heading.nvim",
    },
    lazy = false,
    opts = {
        defaults = {
            file_ignore_patterns = {
                "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.JPG",
                "%.PNG", "%.webp", "%.WEBP", "%.mp3", "%.MP3", "%.pdf",
                "%.PDF", "%.odt", "%.ODT", "%.ico", "%.ICO",
            },
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
                treesitter = false,
                picker_opts = {
                    layout_strategy = "horizontal",
                    sorting_strategy = "ascending",
                    layout_config = {
                        preview_cutoff = 106,
                        preview_width = 0.7,
                    },
                },
            },
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts) -- Order matters
        telescope.load_extension("file_browser")
        telescope.load_extension("heading")
    end,
    keys = function()
        local m = { "n", "v" }
        local telescope = require("telescope.builtin")
        local telescope_ext = require("telescope").extensions
        local file_browser = telescope_ext.file_browser.file_browser
        local find_files_from_filepath = function()
            telescope.find_files({cwd = vim.fn.expand('%:p:h'), hidden = true})
        end

        return {
            { "<leader>ff", telescope.find_files, mode = m, desc = "Telescope: Find files (nvim runtime path)." },
            { "<leader>fF", find_files_from_filepath, mode = m, desc = "Telescope: Find files in the file directory."},
            { "<leader>fg", telescope.live_grep, mode = m, desc = "Telescope: Find grep." },
            { "<leader>fb", telescope.buffers, mode = m, desc = "Telescope: Find buffers." },
            { "<leader>fr", telescope.registers, mode = m, desc = "Telescope: Copy a register." },
            { "<leader>fR", telescope.oldfiles, mode = m, desc = "Telescope: Find recents." },
            { "<leader>fh", telescope.help_tags, mode = m, desc = "Telescope: Find help." },
            { "<leader>fs", telescope.grep_string, mode = "x", desc = "Telescope: Find selected string."},
            { "<leader>fe", file_browser, mode = m, desc = "Telescope: File explorer mode from nvim path." },
            { "<leader>fE", function() file_browser({path="%:p:h", select_buffer=true, hidden=true}) end,
                mode = m, desc = "Telescope: File explorer mode from buffer path."},
            { "<leader>fH", telescope_ext.heading.heading, mode = m, desc = "Telescope: Get document headers (markdown)."},
        }
    end,
}
