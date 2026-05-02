---@type vim.lsp.ClientConfig
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "Dockerfile", "dockerfile" },
  root_markes = { "Dockerfile" },
}
