local config = function()
  local actions = require("telescope.actions")
  require("telescope").setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      dynamic_preview_title = true,
      winblend = 0,
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "bottom",
        height = 0.95,
      },
      mappings = {
        n = {
          ["q"] = "close",
          ["l"] = "select_default",
        },
      },
    },
    file_ignore_patterns = {
      "lazy-lock.json",
    },
    pickers = {
      -- Default config for builtin pickers:
      find_files = {
        hidden = true,
      },
    },
    pcall(require("telescope").load_extension, "file_browser"),
    extensions = {
      file_browser = {
        prompt_title = "פּ  Browser",
        initial_mode = "normal",
        sorting_strategy = "ascending",
        grouped = true,
        hidden = true,
        respect_gitignore = true,
        hide_paren_dir = true,
        hijack_netrw = true,
      },
    },
    require("telescope").load_extension("zf-native"),
  })
end
return config
