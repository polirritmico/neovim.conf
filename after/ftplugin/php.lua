vim.opt_local.formatoptions = vim.opt_local.formatoptions + "r" - "o" - "t"
vim.bo.commentstring = "// %s"

vim.api.nvim_create_user_command(
  "PhpactorInit",
  function() vim.fn.system({ vim.fn.exepath("phpactor"), "config:initialize" }) end,
  { desc = "Generate base .phpactor.json file" }
)

vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

vim.keymap.set("n", "<leader>tL", function()
  if vim.bo.expandtab then
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
    vim.notify("Disabled expandtab")
  else
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    vim.notify("Enabled expandtab")
  end
end, { desc = "toggle tab-4/space-2 size" })
