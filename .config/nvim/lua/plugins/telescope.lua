-- Telescope
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

-- Extensiones:
require("telescope").load_extension("fzf")
