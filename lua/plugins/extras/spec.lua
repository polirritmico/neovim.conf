return {
  --- Active indent guide. Animates the highlight
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      options = { try_as_border = true },
      symbol = "│",
    },
    init = function()
      local disable = function(args) vim.b[args.buf].miniindentscope_disable = true end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "dashboard", "lazy", "mason", "notify", "trouble" },
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
  --- Markdown pseudo-render
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons", -- alternative: "echasnovski/mini.icons",
    },
    ft = { "markdown", "norg", "rmd", "org" },
    keys = {
      -- stylua: ignore
      { "<leader>tm", function() require("render-markdown").toggle() end, ft = "markdown", desc = "RenderMarkdown: Enable/Disable" },
    },
    opts = {
      latex = { enabled = false },
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        min_width = 80,
      },
      heading = {
        enabled = false,
        sign = false,
        icons = {},
      },
    },
  },
  --- Treesitter full `ensure_installed` list
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "comment",
        "diff",
        "gitcommit",
        "html",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
  --- Trouble LSP and diagnostic panels
  {
    "folke/trouble.nvim",
    cond = false,
    cmd = { "Trouble" },
    opts = { modes = { symbols = { win = { position = "left" } } } },
    -- stylua: ignore
    keys = {
      { "<leader>to", "<cmd>Trouble symbols toggle<cr>", desc = "Trouble: Symbols overview" },
      { "<leader>tO", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Filter only current buffer", },
      { "<leader><F1>", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Toggle diagnostic panel" },
      { "[q", function()
          if require("trouble").is_open() then
            ---@diagnostic disable: missing-parameter, missing-fields
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end, desc = "Previous Trouble/Quickfix Item",
      },
      { "]q", function()
          if require("trouble").is_open() then
            ---@diagnostic disable: missing-parameter, missing-fields
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end, desc = "Next Trouble/Quickfix Item",
      },
    },
  },
}
