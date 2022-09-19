-- Telescope

require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true
        }
    },
})

-- Extensiones:
require("telescope").load_extension("fzf")
