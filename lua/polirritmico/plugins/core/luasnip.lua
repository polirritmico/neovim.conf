--- Snippets
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  opts = {
    enable_autosnippets = false,
    -- Don't jump into snippets that have been left
    delete_check_events = "TextChanged,InsertLeave",
    region_check_events = "CursorMoved",
  },
  config = function(_, opts)
    local ls = require("luasnip")
    local types = require("luasnip.util.types")

    -- Add custom snippets
    local custom_snips = vim.fn.stdpath("config") .. "/lua/" .. MyUser .. "/snippets/"
    require("luasnip.loaders.from_lua").load({ paths = { custom_snips } })

    -- Add virtual marks on inputs
    opts.ext_opts = {
      [types.choiceNode] = {
        active = { virt_text = { { "← Choice", "Conceal" } } },
        pasive = { virt_text = { { "← Choice", "Comment" } } },
      },
      [types.insertNode] = {
        active = { virt_text = { { "← Insert", "Conceal" } } },
        pasive = { virt_text = { { "← Insert", "Comment" } } },
      },
    }
    ls.setup(opts)
  end,
  keys = {
    {
      "<c-j>",
      function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip: Expand snippet or jump to the next input index.",
      silent = true,
    },
    {
      "<c-f>",
      function()
        if require("luasnip").jumpable(1) then
          require("luasnip").jump(1)
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip: Jump to the next input index.",
      silent = true,
    },
    {
      "<c-k>",
      function()
        if require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip: Jump to the previous input index.",
      silent = true,
    },
    {
      "<c-l>",
      function()
        if require("luasnip").choice_active() then
          return "<Plug>luasnip-next-choice"
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip: Cycle to the next choice in the snippet.",
      silent = true,
      expr = true,
    },
    {
      "<c-h>",
      function()
        if require("luasnip").choice_active() then
          return "<Plug>luasnip-prev-choice"
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip: Cycle to the previous choice in the snippet.",
      silent = true,
      expr = true,
    },
  },
}
