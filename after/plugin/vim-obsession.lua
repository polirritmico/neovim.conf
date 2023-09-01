-- Vim Obsession
if not Check_loaded_plugin("vim-obsession") then return end

-- Load the session file if founded on the current working directory
local session_file = "Session.vim"
if vim.fn.filereadable(session_file) == 1 then
    vim.cmd("source " .. session_file)
end
