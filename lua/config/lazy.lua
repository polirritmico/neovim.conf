--- Lazy

-- Bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---@type LazyConfig
local opts = {
  change_detection = { notify = false },
  defaults = { lazy = true },
  dev = { path = MyPluginsPath, fallback = false },
  install = { colorscheme = { "monokai-nightasty" } },
  lockfile = vim.fn.stdpath("state") .. "/lazy/lazy-lock.json",
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zip",
        "zipPlugin",
      },
    },
  },
  ui = { border = "rounded" },
}

---@type table<LazySpecImport>
local plugins = {
  { import = "plugins" },
  { import = "plugins.extras", cond = Workstation },
}

require("lazy").setup(plugins, opts)

vim.keymap.set({ "n" }, "<leader>cl", "<Cmd>Lazy<CR>", { desc = "Lazy: Open panel" })
