--- Lualine: Status bar
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    -- PERF: Replace lualine_require (wtf?!) with nvim require
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    return {
      options = { theme = "monokai-nightasty" },
      -- TODO: Make this section
      --sections = {
      --    lualine_c = {
      --        function() return vim.fn.ObsessionStatus("", "") end,
      --        { "filename", path = 4, shorting_target = 45 }
      --    },
      --},
      extensions = { "lazy" },
    }
  end,
}
