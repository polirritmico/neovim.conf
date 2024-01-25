--- Telescope: Searches with fzf
local on_load = require(MyUser .. ".utils").on_load
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  tag = "0.1.5",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
      config = function()
        on_load("telescope.nvim", function()
          require("telescope").load_extension("fzf")
        end)
      end,
    },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "crispgm/telescope-heading.nvim" },
  },
  -- stylua: ignore
  keys = {
    -- Builtins
    { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope: Find files (nvim runtime path)" },
    { "<leader>fF", "<Cmd>Telescope find_files cwd=%:p:h hidden=true<CR>", desc = "Telescope: Find files (from file path)" },
    { "<leader>fb", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Telescope: Find/Switch between buffers" },
    { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope: Find Grep" },
    { "<leader>fg", "<Cmd>Telescope grep_string<CR>", mode = "x", desc = "Telescope: Find Grep (selected string)" },
    { "<leader>fr", "<Cmd>Telescope registers<CR>", mode = { "n", "v" }, desc = "Telescope: Select and paste from registers" },
    { "<leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Telescope: Find recent/old files" },
    { "<leader>fl", "<Cmd>Telescope resume<CR>", desc = "Telescope: List results of the last telescope search" },
    { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope: Find in help tags" },
    { "<leader>fm", "<Cmd>Telescope marks<CR>", desc = "Telescope: Find buffer marks" },
    { "<leader>fT", "<Cmd>Telescope<CR>", desc = "Telescope: Find telescope builtins functions" },
    { "zf", "<Cmd>Telescope spell_suggest<CR>", desc = "Telescope: Find spell word suggestion" },

    -- Configs
    { "<leader>cs", [[<Cmd>execute "Telescope find_files cwd=".MyConfigPath."snippets/"<CR>]], desc = "Telescope: Snippets sources" },
    { "<leader>cc", [[<Cmd>execute "Telescope find_files cwd=".MyConfigPath<CR>]], desc = "Telescope: Configurations" },
    { "<leader>ct", [[<Cmd>execute "Telescope find_files cwd=".stdpath("config")."/after/ftplugin"<CR>]], desc = "Telescope: Configurations" },

    -- Extensions
    { "<leader>fe", "<Cmd>Telescope file_browser<CR>", desc = "Telescope: File explorer from nvim path" },
    { "<leader>fE", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR> hidden=true<cr>", desc = "Telescope: File explorer mode from buffer path." },
    { "<leader>fH", "<Cmd>Telescope heading<CR>", ft = "markdown", desc = "Telescope: Get document headers (markdown)." },
  },
  opts = function()
    local layout_strategy, layout_config
    if Workstation then
      layout_strategy = "flex"
      layout_config = {
        flex = { flip_columns = 120 },
        horizontal = { preview_width = { 0.6, max = 100, min = 30 } },
      }
    else
      layout_strategy = "vertical"
      layout_config = { vertical = { preview_cutoff = 20, preview_height = 9 } }
    end

    -- stylua: ignore
    local file_ignore_patterns = {
      "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.webp", "%.mp3",
      "%.pdf", "%.odt", "%.ico", "%.ttf", "%.zip"
    }
    for i = 1, #file_ignore_patterns do
      table.insert(file_ignore_patterns, file_ignore_patterns[i]:upper())
    end

    return {
      defaults = {
        file_ignore_patterns = file_ignore_patterns,
        layout_strategy = layout_strategy,
        layout_config = layout_config,
        path_display = { "truncate" },
        prompt_prefix = "   ",
        selection_caret = " 󰄾  ",
        sorting_strategy = "ascending",
        mappings = { i = { ["<C-h>"] = "which_key" } }, -- toggle keymaps help
      },
      extensions = {
        file_browser = {
          follow_symlinks = true,
        },
        heading = {
          treesitter = false,
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
    }
  end,
}
