-- Pairs of (), [], {}, etc.
return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-cmp" },
    opts = {
        enable_check_bracket_line = true,
        fast_wrap = {
            map = "<M-e>",
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = "L",
            keys = "asdfghjklqwertyuiopzxcvbnm",
            check_comma = true,
            manual_position = true,
            highlight = "Search",
            highlight_grey="Comment",
        },
    },
    config = function(_, opts)
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        npairs.setup(opts)

        -- Add symmetrical spaces:
        local brackets = { { "(", ")" }, { "[", "]"}, { "{", "}" } }
        npairs.add_rules({
            Rule(" ", " ")
            :with_pair(function(_opts)
                local pair = _opts.line:sub(_opts.col -1, _opts.col)
                return vim.tbl_contains({
                    brackets[1][1]..brackets[1][2],
                    brackets[2][1]..brackets[2][2],
                    brackets[3][1]..brackets[3][2]
                }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(_opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local context = _opts.line:sub(col - 1, col + 2)
                return vim.tbl_contains({
                    brackets[1][1].."  "..brackets[1][2],
                    brackets[2][1].."  "..brackets[2][2],
                    brackets[3][1].."  "..brackets[3][2]
                }, context)
            end)
        })
        for _, bracket in pairs(brackets) do
            Rule("", " "..bracket[2])
            :with_pair(cond.none())
            :with_move(function(_opts) return _opts.char == bracket[2] end)
            :with_cr(cond.none())
            :with_del(cond.none())
            :use_key(bracket[2])
        end

        -- Integrate with cmp: Insert "(" after select function or method item
        require("cmp").event:on(
            "confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
    end,
}
