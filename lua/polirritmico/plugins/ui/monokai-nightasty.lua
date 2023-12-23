--- Best colorscheme for nvim

-- local map = require(MyUser .. ".utils").set_keymap

return {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    dev = true,
    keys = {
        { "<leader>tt", "<CMD>MonokaiToggleLight<CR>", mode = "n",
            desc = "Monokai-Nightasty: Toggle dark/light theme." },
    },
    config = function()
        -- To reload `:Lazy reload monokai-nightasty.nvim`
        local opts = {
            dark_style_background = "default",
            light_style_background = "default",
            color_headers = false,
            lualine_bold = true,
            lualine_style = "default",
            -- hl_styles = { comments = { italic = false } },
        }

        vim.opt.cursorline = true  -- Highlight line at the cursor position
        vim.o.background = "dark"  -- Default to dark theme

        -- Change to light between 16 and 19:30
        local date_output = vim.api.nvim_exec2("!date +'\\%H\\%M'", {output = true})
        local system_time = tonumber(string.match(date_output["output"], "%d%d%d%d"))
        if system_time >= 1600 and system_time < 1930 then
            vim.o.background = "light"
        end

        require("monokai-nightasty").setup(opts)
        vim.cmd.colorscheme("monokai-nightasty")
    end,
}
