-- UltiSnips
if type(packer_plugins) ~= "table" or packer_plugins["ultisnips"] == nil then
	return
end

-- UltiSnips stuff 
vim.g.UltiSnipsSnippetDirectories = {"lua/polirritmico/snips", "UltiSnips"}

-- Trigger
vim.g.UltiSnipsExpandTrigger = "<C-j>"
vim.g.UltiSnipsJumpForwardTrigger = "<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"

