-- Greeter screen
return {
    "nvimdev/dashboard-nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    event = "VimEnter",
    opts = function()
        local opts = {
            theme = "doom",
            hide = {
                statusline = false, -- handled by Lualine itself
            },
            config = {
                header = {
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
                    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
                    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
                    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
                    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
                    "",
                    "",
                    "",
                },
                center = {
                    {
                        action = "ene | startinsert",
                        desc = " New file",
                        icon = " ",
                        key = "e",
                    },
                    {
                        action = "Telescope find_files",
                        desc = " Find file",
                        icon = " ",
                        key = "<leader>ff",
                    },
                    {
                        action = "Telescope oldfiles",
                        desc = " Recent files",
                        icon = " ",
                        key = "<leader>fr",
                    },
                    {
                        action = "Telescope live_grep",
                        desc = " Find text",
                        icon = " ",
                        key = "<leader>fg",
                    },
                    {
                        action = "Telescope help_tags",
                        desc = " Help docs",
                        -- icon = "󰋖 ",
                        icon = "󰘥 ",
                        key = "<leader>fh",
                    },
                    {
                        action = [[lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })]],
                        desc = " Config",
                        icon = " ",
                        key = "<leader>cc",
                    },
                    -- { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                    {
                        action = "Lazy",
                        desc = " Plugins",
                        icon = "󰒲 ",
                        key = "<leader>cl",
                    },
                    { action = "qa", desc = " Quit", icon = " ", key = "q" },
                },
                footer = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    return {
                        "⚡ Neovim loaded "
                            .. stats.loaded
                            .. "/"
                            .. stats.count
                            .. " plugins in "
                            .. ms
                            .. "ms",
                    }
                end,
            },
        }

        for _, button in ipairs(opts.config.center) do
            button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
            button.key_format = "  %s"
        end

        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "DashboardLoaded",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        return opts
    end,
}
