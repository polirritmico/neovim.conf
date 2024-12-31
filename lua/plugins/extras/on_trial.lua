local utils = require("utils") ---@type MyUtils

return {
  --- Autocompletion (nvim-cmp config backup)
  {
    "hrsh7th/nvim-cmp",
    cond = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      "LuaSnip",
    },
    config = function(_, opts)
      CmpLspPlugin = "cmp-nvim-lsp" ---@type string Lsp source plugin for autocompletion
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", opts.cmdline)
    end,
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      local win_opts = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }

      return {
        completion = { completeopt = "menu,menuone,noinsert" },
        enabled = utils.plugins.cmp_enabled,
        formatting = {
          expandable_indicator = false, -- shows the ~ symbol when expandable
          fields = { "abbr", "menu", "kind" }, -- suggestions order :h formatting.fields
          format = utils.plugins.cmp_custom_menu(25),
        },
        mapping = {
          ["<C-j>"] = cmp.mapping.confirm({
            behaviour = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          -- NOTE: cmp.mapping.scroll_docs does not work with the lsp's hover
          -- window, so use <S-K> again to change the focus into it.
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ select = true })
            elseif luasnip.choice_active() then
              luasnip.change_choice(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-e>"] = function()
            vim.b.disable_cmp = not vim.b.disable_cmp
            if vim.b.disable_cmp then
              cmp.abort()
            else
              cmp.complete()
            end
          end,
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        sorting = vim.tbl_extend("force", defaults.sorting, {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            utils.plugins.cmp_custom_sorter,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        }),
        -- Order of menu entries
        sources = cmp.config.sources({
          { name = "path", keyword_length = 2 },
          { name = "nvim_lsp", keyword_length = 2 },
          {
            name = "luasnip",
            keyword_length = 2,
            -- Disable filtering completion candidates by snippet's show_condition:
            option = { use_show_condition = false },
          },
        }, {
          { name = "buffer", keyword_length = 3 },
        }, {
          { name = "calc", keyword_length = 3 },
        }),
        -- Add border to popup window
        window = {
          -- NOTE: Max menu height size is controlled by nvim pumheight option
          completion = cmp.config.window.bordered(win_opts),
          documentation = cmp.config.window.bordered(win_opts),
        },
        -- Custom extended cmdline opts
        cmdline = {
          completion = { completeopt = "menu,menuone,noselect" },
          mapping = cmp.mapping.preset.cmdline({
            ["<C-j>"] = { c = function() cmp.confirm({ select = true }) end },
            ["<Tab>"] = {
              c = function()
                if cmp.visible() then
                  if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                  else
                    cmp.select_next_item()
                  end
                else
                  cmp.complete()
                end
              end,
            },
          }),
          sources = cmp.config.sources(
            { { name = "path" } },
            { { name = "cmdline", keyword_length = 4 } }
          ),
        },
      }
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 999,
    lazy = false,
    cond = false,
    keys = {
      {
        "<leader>ps",
        function() Snacks.profiler.scratch() end,
        desc = "Profiler Scratch Buffer",
      },
    },
    opts = function()
      Snacks.toggle.profiler():map("<leader>pp")
      Snacks.toggle.profiler_highlights():map("<leader>ph")
      return {
        notifier = { enabled = true },
        profiler = {
          pick = { preview = { align = "left" } },
        },
        dashboard = {
          preset = {
            header = "Neovim :: E B R Λ Y\n🄯 2024",
          -- stylua: ignore
          keys = {
            { icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "<leader>ss", desc = "Restore Session", action = require("utils.plugins").mini_sessions_manager },
            { icon = " ", key = "<leader>ff", desc = "Find file", action = ":Telescope find_files" },
            { icon = " ", key = "<leader>fr", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = "󰖷 ", key = "<F10>", desc = "Debug session", action = ":lua require('osv').launch({ port = 8086 })" },
            { icon = " ", key = "<leader>cc", desc = "Config files", action = ":Telescope find_files cwd=~/.config/nvim" },
            { icon = " ", key = "<leader>cp", desc = "Config plugins", action = ":Telescope lazy_plugins" },
            { icon = "󰒲 ", key = "<leader>cl", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          },
        },
      }
    end,
  },
}
