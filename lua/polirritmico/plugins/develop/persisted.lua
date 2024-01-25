--- Session Manager
return {
  "olimorris/persisted.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = {
    "SessionToggle",
    "SessionStart",
    "SessionStop",
    "SessionSave",
    "SessionLoad",
    "SessionLoadLast",
    "SessionLoadFromFile",
    "SessionDelete",
    "Telescope persisted",
  },
  -- stylua: ignore
  keys = {
    { "<leader>sw", "<Cmd>SessionSave<CR>", desc = "Persisted: Session save" },
    { "<leader>sl", "<Cmd>SessionLoad<CR>", desc = "Persisted: Session load" },
    { "<leader>sd", "<Cmd>SessionDelete<CR>", desc = "Persisted: Delete current session" },
    { "<leader>sh", "<Cmd>SessionLoadLast<CR>", desc = "Persisted: Halt session recording" },
    { "<leader>sr", "<Cmd>SessionLoadLast<CR>", desc = "Persisted: Load most recent session" },
    { "<leader>fs", "<Cmd>Telescope persisted<CR>", desc = "Persisted: Find sessions in Telescope" },
  },
  opts = {
    save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
    silent = false, -- message when sourcing session file
    use_git_branch = true, -- sessions based on the branch of a git repo
    autoload = false, -- load the session for the cwd on nvim startup
    follow_cwd = true, -- change session file name to match cwd if it changes
    -- ignore_dirs = nil, -- table of dirs ignored on auto-save/auto-load
    autosave = true, -- save sessions on exit
    should_autosave = function()
      return vim.bo.filetype ~= "dashboard" -- not autosave on dashboard
    end,
  },
}
