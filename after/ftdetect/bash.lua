vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = vim.api.nvim_create_augroup("CustomShebangDetection", {}),
  desc = "Set Bash filetype based on is_bash and is_sh variables",
  callback = function()
    if vim.b.is_bash and not vim.b.is_sh then
      vim.api.nvim_set_option_value("filetype", "bash", { buf = 0 })
    end
  end,
})
