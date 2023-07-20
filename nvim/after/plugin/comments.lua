-- Comment.nvim
local plugin_name = "Comment.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

require("Comment").setup({
    padding = true, -- Add a space b/w comment and the line
    sticky = true, -- Whether the cursor should stay at its position
    ignore = nil, -- Lines to be ignored while (un)comment
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
        line = 'gcc', -- Line-comment toggle keymap
        block = 'gbc', -- Block-comment toggle keymap
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        line = 'gc', -- Line-comment keymap
        block = 'gb', -- Block-comment keymap
    },
    -- LHS of extra mappings
    extra = {
        above = 'gcO', -- Add comment on the line above
        below = 'gco', -- Add comment on the line below
        eol = 'gcA', -- Add comment at the end of line
    },
    -- Enable keybindings
    mappings = { -- could be false
        -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        -- Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    pre_hook = nil, -- Function to call before (un)comment
    post_hook = nil, -- Function to call after (un)comment
})
