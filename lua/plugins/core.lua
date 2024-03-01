--- Autocompletion
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      return {
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = {
          ["<C-j>"] = cmp.mapping.confirm({
            behaviour = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          -- NOTE: cmp.mapping.scroll_docs does not work with lsp's hover window.
          -- Use <C-w><C-w> to change the focus into the hover.
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Up>"] = cmp.mapping.select_prev_item({ select = true }),
          ["<Down>"] = cmp.mapping.select_next_item({ select = true }),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ select = true })
            elseif luasnip.choice_active() then
              luasnip.change_choice(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources({
          -- Order of cmp menu entries
          { name = "path", keyword_length = 2 },
          { name = "nvim_lsp", keyword_length = 2 },
          {
            name = "luasnip",
            keyword_length = 2,
            option = { use_show_condition = false }, -- disable filtering completion candidates by snippet's show_condition
          },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
        formatting = {
          expandable_indicator = true, -- shows the ~ symbol when expandable
          fields = { "abbr", "menu", "kind" }, -- suggestions order :h formatting.fields
          format = function(entry, item)
            local short_name = {
              nvim_lsp = "LSP",
              nvim_lua = "nvim",
            }
            local menu_name = short_name[entry.source.name] or entry.source.name
            item.menu = string.format("[%s]", menu_name)
            return item
          end,
        },
        experimental = {
          ghost_text = { hl_group = "CmpGhostText" },
        },
        enabled = function()
          -- Disable on telescope prompt
          if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
            return false
          end

          -- Disable completion on comments
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
          end
        end,
        sorting = vim.tbl_extend("force", defaults.sorting, {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- Sort python dunder and private methods to the btm
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        }),
        -- Add border to popup window
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
    end,
  },
  --- Formatter
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "FormatEnable", "FormatDisable" },
    keys = {
      {
        "<F3>",
        function() require("conform").format({ async = false, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Conform: Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        ["*"] = { "trim_whitespace" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Only apply format if `disable_autoformat` is not true
        if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
          return { timeout_ms = 500, lsp_fallback = true }
        end
      end,
      formatters = {
        black = { prepend_args = { "--line-length", "88" } },
        prettier = { prepend_args = { "--tab-width", "2" } },
        shfmt = { prepend_args = { "-i", "4" } },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }, -- overwrites stylua.toml
      },
    },
    init = function() vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]] end,
    config = function(_, opts)
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- :FormatDisable!<CR>
          vim.b[0].disable_autoformat = true
          vim.notify("Disabled autoformat-on-save just for the current buffer.")
        else
          -- :FormatDisable<CR>
          vim.g.disable_autoformat = true
          vim.notify("Disabled autoformat-on-save.")
        end
      end, {
        desc = "Disable autoformat-on-save. Append `!` to affect only the current buffer.",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b[0].disable_autoformat = false
        vim.g.disable_autoformat = false
        vim.notify("Enabled autoformat-on-save.")
      end, {
        desc = "Enable autoformat-on-save",
      })

      require("conform").setup(opts)
    end,
  },
  --- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/neodev.nvim", config = true },
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lsp = require("mason-lspconfig")

      --- Keys

      local function toggle_lsp_diag()
        if vim.diagnostic.is_disabled() then
          vim.diagnostic.enable()
        else
          vim.diagnostic.disable()
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local buf_opts = { buffer = event.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, buf_opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, buf_opts)
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, buf_opts)
          -- <F3> (format current buffer) is handled by Conform
          vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, buf_opts)

          vim.keymap.set("n", "<F1>", vim.diagnostic.open_float, buf_opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf_opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf_opts)
          vim.keymap.set({ "n", "v" }, "<leader>gH", toggle_lsp_diag, buf_opts)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, buf_opts)
        end,
      })

      --- Servers configurations `:h lspconfig-configurations`
      local function default_setup(server) lspconfig[server].setup({}) end

      local function config_clangd()
        lspconfig.clangd.setup({
          cmd = { "clangd", "--fallback-style=WebKit" },
        })
      end

      local function config_lua_ls()
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end

      local function config_pylsp()
        lspconfig.pylsp.setup({
          settings = {
            pylsp = {
              plugins = {
                black = { enabled = true },
                pylsp_mypy = { enabled = true },
                pycodestyle = {
                  maxLineLength = 88,
                  ignore = { "E203", "E265", "E501", "W391", "W503" },
                },
              },
            },
          },
        })
      end

      local function config_texlab()
        lspconfig.texlab.setup({
          settings = { texlab = { latexFormatter = "texlab" } },
        })
      end

      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        "force",
        lsp_defaults.capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Apply servers configurations
      mason_lsp.setup({
        ensure_installed = { "bashls", "clangd", "lua_ls", "pylsp" },
        handlers = {
          default_setup,
          clangd = config_clangd,
          lua_ls = config_lua_ls,
          pylsp = config_pylsp,
          texlab = config_texlab,
        },
      })

      -- Add borders to LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- Add borders to Hover when Noice is not in the Lazy plugins spec.
      if not require("lazy.core.config").spec.plugins["noice.nvim"] then
        vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      end
    end,
  },
  --- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    opts = {
      enable_autosnippets = false,
      -- Don't jump into snippets that have been left
      delete_check_events = "TextChanged,InsertLeave",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      -- Add custom snippets
      local custom_snips = NeovimPath .. "/lua/snippets/"
      require("luasnip.loaders.from_lua").load({ paths = { custom_snips } })

      -- Add virtual marks on inputs
      opts.ext_opts = {
        [types.choiceNode] = {
          active = { virt_text = { { "← Choice", "Conceal" } } },
          pasive = { virt_text = { { "← Choice", "Comment" } } },
        },
        [types.insertNode] = {
          active = { virt_text = { { "← Insert", "Conceal" } } },
          pasive = { virt_text = { { "← Insert", "Comment" } } },
        },
      }
      ls.setup(opts)
    end,
    keys = {
      {
        "<C-j>",
        function()
          if require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Expand snippet or jump to the next input index.",
        silent = true,
      },
      {
        "<C-f>",
        function()
          if require("luasnip").jumpable(1) then
            require("luasnip").jump(1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Jump to the next input index.",
        silent = true,
      },
      {
        "<C-k>",
        function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Jump to the previous input index.",
        silent = true,
      },
      {
        "<C-l>",
        function()
          if require("luasnip").choice_active() then
            return "<Plug>luasnip-next-choice"
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Cycle to the next choice in the snippet.",
        silent = true,
        expr = true,
      },
      {
        "<C-h>",
        function()
          if require("luasnip").choice_active() then
            return "<Plug>luasnip-prev-choice"
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Cycle to the previous choice in the snippet.",
        silent = true,
        expr = true,
      },
    },
  },
  --- Mason package manager for non-nvim tools
  {
    "williamboman/mason.nvim",
    build = { ":MasonUpdate" },
    cmd = "Mason",
    keys = {
      { "<leader>cM", "<Cmd>Mason<CR>", desc = "Mason: Open panel" },
    },
    opts = {
      ensure_installed = {
        "bash-language-server", -- Bash language server
        "clangd", -- LSP for C/C++
        "lua-language-server", -- Lua language server
        "stylua", -- Lua code formatter
        "prettier", -- Formater for css, html, json, javascript, yaml and more.
        "python-lsp-server", -- fork of python-language-server
      },
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- trigger FileType event to try loading newly installed servers
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  --- Telescope: Searches with fzf
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    tag = "0.1.5",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("utils").config.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("fzf") end
          )
        end,
      },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "crispgm/telescope-heading.nvim" },
      { "polirritmico/telescope-lazy-plugins.nvim", dev = false },
    },
    -- stylua: ignore
    keys = {
      -- Builtins
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope: Find files (nvim runtime path)" },
      { "<leader>fF", "<Cmd>Telescope find_files cwd=%:p:h hidden=true<CR>", desc = "Telescope: Find files (from file path)" },
      { "<leader>fb", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Telescope: Find/Switch between buffers" },
      { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope: Find grep" },
      { "<leader>fg", "<Cmd>Telescope grep_string<CR>", mode = "x", desc = "Telescope: Find Grep (selected string)" },
      { "<leader>fr", "<Cmd>Telescope registers<CR>", mode = { "n", "v" }, desc = "Telescope: Select and paste from registers" },
      { "<leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Telescope: Find recent/old files" },
      { "<leader>fl", "<Cmd>Telescope resume<CR>", desc = "Telescope: List results of the last telescope search" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope: Find in help tags" },
      { "<leader>fm", "<Cmd>Telescope marks<CR>", desc = "Telescope: Find buffer marks" },
      { "<leader>fT", "<Cmd>Telescope<CR>", desc = "Telescope: Find telescope builtins functions" },
      { "zf", "<Cmd>Telescope spell_suggest<CR>", desc = "Telescope: Find spell word suggestion" },

      -- Configs
      { "<leader>cs", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/lua/snippets/"<CR>]], desc = "Telescope: Snippets sources" },
      { "<leader>ct", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/after/ftplugin/"<CR>]], desc = "Telescope: Filetypes configurations" },
      { "<leader>cc", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath<CR>]], desc = "Telescope: Plugins configurations" },
      { "<leader>cp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope: Config plugins" },

      -- Extensions
      { "<leader>fe", "<Cmd>Telescope file_browser<CR>", desc = "Telescope: File explorer from nvim path" },
      { "<leader>fE", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR> hidden=true<cr>", desc = "Telescope: File explorer mode from buffer path." },
      { "<leader>fH", "<Cmd>Telescope heading<CR>", ft = "markdown", desc = "Telescope: Get document headers (markdown)." },
    },
    opts = function()
      local layout_strategy, layout_config
      if Workstation then
        layout_strategy = "flex"
        layout_config = {
          flex = { flip_columns = 120 },
          horizontal = { preview_width = { 0.6, max = 100, min = 30 } },
        }
      else
        layout_strategy = "vertical"
        layout_config = { vertical = { preview_cutoff = 20, preview_height = 9 } }
      end

      -- stylua: ignore
      local file_ignore_patterns = {
        "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.webp", "%.mp3",
        "%.pdf", "%.odt", "%.doc", "%.docx", "%.epub", "%.ico", "%.ttf", "%.zip",
      }
      for i = 1, #file_ignore_patterns do
        table.insert(file_ignore_patterns, file_ignore_patterns[i]:upper())
      end

      return {
        defaults = {
          file_ignore_patterns = file_ignore_patterns,
          layout_strategy = layout_strategy,
          layout_config = layout_config,
          path_display = { "truncate" },
          prompt_prefix = "   ",
          selection_caret = "󰄾 ",
          sorting_strategy = "ascending",
          mappings = {
            ["i"] = {
              ["<C-h>"] = "which_key", -- toggle keymaps help
              ["<LeftMouse>"] = function() end,
            },
            ["n"] = {
              ["<LeftMouse>"] = function() end,
            },
          },
        },
        extensions = {
          file_browser = {
            follow_symlinks = true,
          },
          lazy_plugins = {
            show_disabled = true,
          },
          heading = {
            treesitter = false,
            picker_opts = {
              layout_strategy = "horizontal",
              sorting_strategy = "ascending",
              layout_config = {
                preview_cutoff = 20,
                preview_width = 0.7,
              },
            },
          },
        },
      }
    end,
  },
  --- Treesitter: Parse program langs for highlights, indent, conceals, etc.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    init = function(plugin)
      -- PERF: (From LazyVim): Add TS queries to the rtp early for plugins
      -- which don't trigger **nvim-treesitter** module to be loaded in time.
      -- This make available the custom queries needed by those plugins.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      -- full list in plugins/extras/treesitter
      ensure_installed = {
        "bash",
        "comment",
        "gitcommit",
        "lua",
        "markdown",
        "python",
        "regex",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
}
