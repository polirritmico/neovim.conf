--- Best colorscheme for nvim
-- To reload use `:Lazy reload monokai-nightasty.nvim`
return {
  "polirritmico/monokai-nightasty.nvim",
  lazy = false,
  priority = 1000,
  dev = false,
  keys = {
    {
      "<leader>tt",
      "<Cmd>MonokaiToggleLight<CR>",
      desc = "Monokai-Nightasty: Toggle dark/light theme.",
    },
  },
  opts = {
    dark_style_background = "transparent",
    light_style_background = "default",
    color_headers = false,
    lualine_bold = true,
    lualine_style = "default",
    -- hl_styles = { comments = { italic = false } },
  },
  config = function(_, opts)
    vim.opt.cursorline = true -- Highlight line at the cursor position
    vim.o.background = "dark" -- Default to dark theme

    -- Change to light between time
    local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", { output = true })
    local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))
    if system_time >= 1400 and system_time < 1930 then
      vim.o.background = "light"
    end

    require("monokai-nightasty").load(opts)
  end,
}
