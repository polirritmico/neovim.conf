-- LSP signature
local plugin_name = "lsp_signature.nvim"
if not Check_loaded_plugin(plugin_name) then
    return
end

local config = {
    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible
    close_timeout = 2000, -- close floating window after ms when laster parameter is entered
    hint_enable = true, -- virtual hint enable
    hint_prefix = " ",  -- Panda for parameter,  NOTE: For the terminal not support emoji, might crash
    hint_scheme = "String",
    handler_opts = {border = "rounded" },  -- double, rounded, single, shadow, none, or a table of borders
    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = "<A-i>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    toggle_key_flip_floatwin_setting = true, -- true: toggle float setting after toggle key pressed
    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

require("lsp_signature").setup(config)

