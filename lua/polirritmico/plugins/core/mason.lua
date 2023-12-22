--- Mason package manager for non-nvim tools

local dap_python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/"
return {
    "williamboman/mason.nvim",
    dependencies = {
        {"WhoIsSethDaniel/mason-tool-installer.nvim"}, -- debugpy
    },
    build = {
        ":MasonUpdate",
        "source " .. dap_python_path .. "activate; python -m pip install pytest; deactivate",
    },
    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = { "debugpy", },
            run_on_start = true,
        })
    end,
}
