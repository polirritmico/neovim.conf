-- Delete buffers without messing up the current layout

return {
    "famiu/bufdelete.nvim",
    keys = function()
        return {
            { "<leader>db", function() require("bufdelete").bufdelete(0, true) end, {"n", "v"},
                desc = "bufdelete: Fercibly delete the current buffer.", silent = true },
        }
    end,
}
