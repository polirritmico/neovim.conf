--- Save sessions

return {
    "tpope/vim-obsession",
    enabled = false,
    config = function()
        local session_file = "Session.vim"
        if vim.fn.filereadable(session_file) == 1 then
            vim.cmd("source " .. session_file)
        end
    end,
}
