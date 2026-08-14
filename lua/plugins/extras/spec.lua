return {
  --- Active indent guide. Animates the highlight
  {
    "nvim-mini/mini.indentscope",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      options = { try_as_border = true },
      symbol = "│",
    },
    init = function()
      local disable = function(args) vim.b[args.buf].miniindentscope_disable = true end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "dashboard",
          "lazy",
          "mason",
          "notify",
          "trouble",
          "neotest-summary",
        },
        callback = disable,
      })
      vim.api.nvim_create_autocmd("TermOpen", { callback = disable })
    end,
  },
  --- Center buffer on screen
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    enabled = true,
    cmd = "NoNeckPain",
    opts = {
      autocmds = {
        reloadOnColorSchemeChange = true,
      },
      buffers = {
        bo = { filetype = "md" },
        right = { enabled = false },
        wo = { fillchars = "eob: " }, -- Hide ~ from spacebuffers
      },
      width = 100,
    },
    keys = function()
      local toggle_state = false
      local border_hl

      local function toggle_custom_hl_border()
        local border_name = "WinSeparator"
        local custom_hl = { fg = 4079166 } -- "#3e3e3e" in dec

        if not border_hl then
          border_hl = vim.api.nvim_get_hl(0, { name = border_name })
        end

        if toggle_state then
          ---@cast border_hl vim.api.keyset.highlight
          vim.api.nvim_set_hl(0, border_name, border_hl)
        else
          vim.api.nvim_set_hl(0, border_name, custom_hl)
        end
        toggle_state = not toggle_state
        vim.cmd([[NoNeckPain]])
      end

      return {
        -- stylua: ignore
        { "<leader>tc", toggle_custom_hl_border, mode = { "n", "v" }, desc = "NoNeckPain: Toggle center mode" },
      }
    end,
  },
  --- Gentoo syntax
  { "gentoo/gentoo-syntax", enabled = Workstation },
  --- Some UI improvements
  {
    "stevearc/dressing.nvim", -- Archived
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = true,
  },
  --- Local patches to plugins installed through lazy.nvim
  {
    "polirritmico/lazy-local-patcher.nvim",
    config = true,
    dev = false and not DisableMyPlugins,
    ft = "lazy",
  },
  --- Markdown pseudo-render
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "norg", "rmd", "org" },
    -- stylua: ignore
    keys = {
      { "<leader>mt", function() require("render-markdown").toggle() end, ft = "markdown", desc = "RenderMarkdown: Enable/Disable" },
    },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        min_width = 80,
        border = "thick",
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
      file_types = { "markdown", "norg", "rmd", "org" },
      heading = {
        enabled = false,
        sign = false,
        icons = {},
      },
      html = {
        comment = { conceal = false },
      },
      latex = { enabled = false },
      log_level = "off",
    },
  },
  --- Treesitter full `ensure_installed` list
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "css",
        "diff",
        "gitcommit",
        "html",
        "java",
        "json",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "sql",
        "toml",
        "tsx",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
}
