local utils = require("utils") ---@type Utils

return {
  --- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
      "LuaSnip",
    },
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", opts.cmdline)
    end,
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      return {
        completion = { completeopt = "menu,menuone,noinsert" },
        -- experimental = { ghost_text = true },

        enabled = function()
          -- Disable on telescope prompt
          if vim.api.nvim_get_option_value("buftype", {}) == "prompt" then
            return false
          end

          -- Disable on comments
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
          end
        end,

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

        mapping = {
          ["<C-j>"] = cmp.mapping.confirm({
            behaviour = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          -- NOTE: cmp.mapping.scroll_docs does not work with lsp's hover window.
          -- Use <S-K> again to change the focus into the hover.
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

        performance = { max_view_entries = 12 },

        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },

        -- Sort python dunder and private methods to the btm
        -- Source: https://github.com/lukas-reineke/cmp-under-comparator
        sorting = vim.tbl_extend("force", defaults.sorting, {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
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
        }, {
          { name = "calc", keyword_length = 3 },
        }),

        -- Add border to popup window
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- Custom extended cmdline opts
        cmdline = {
          completion = { completeopt = "menu,menuone,noselect" },
          mapping = cmp.mapping.preset.cmdline({
            ["<C-j>"] = { c = function() cmp.confirm({ select = true }) end },
            ["<Tab>"] = {
              c = function()
                if cmp.visible() then
                  if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                  else
                    cmp.select_next_item()
                  end
                else
                  cmp.complete()
                end
              end,
            },
          }),
          sources = cmp.config.sources(
            { { name = "path" } },
            { { name = "cmdline", keyword_length = 4, max_item_count = 10 } }
          ),
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
    -- stylua: ignore
    keys = {
      { "<F3>", function() require("conform").format({ async = false, lsp_fallback = true }) end, mode = { "n", "v" }, desc = "Conform: Format buffer" },
      { "<leader>tf", utils.plugins.conform_toggle, desc = "Conform: Enable/Disable autoformat-on-save." },
    },
    opts = {
      log_level = nil, -- default: vim.log.levels.ERROR
      formatters_by_ft = {
        ["*"] = { "trim_whitespace" },
        css = { "prettier" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier_markdown", "markdown-toc" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        yaml = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- Only apply format if `disable_autoformat` is not true
        if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
          return { timeout_ms = 500, lsp_fallback = true }
        end
      end,
      formatters = {
        black = { prepend_args = { "--line-length", "88" } },
        djlint = { prepend_args = { "--indent", "2" } },
        prettier = { prepend_args = { "--tab-width", "2" } },
        shfmt = { prepend_args = { "-i", "4" } },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }, -- overwrites stylua.toml
      },
    },
    init = function() vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]] end,
    config = function(_, opts)
      require("conform").setup(opts)

      -- Add custom options for markdown prettier
      local markdown_formatter = vim.deepcopy(require("conform.formatters.prettier"))
      require("conform.util").add_formatter_args(markdown_formatter, {
        "--prose-wrap",
        "always",
        "--print-width",
        "80",
      }, { append = false })
      ---@cast markdown_formatter conform.FormatterConfigOverride
      require("conform").formatters.prettier_markdown = markdown_formatter
    end,
  },
  --- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      --- Keys

      local function toggle_lsp_diag()
        local state = vim.diagnostic.is_enabled()
        vim.diagnostic.enable(not state)
        vim.notify("LSP: Diagnostics " .. (state and "disabled" or "enabled"))
      end

      local function lspkey(key, fn, desc, ev)
        vim.keymap.set("n", key, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        desc = "LSP actions",
        -- stylua: ignore
        callback = function(event)
          local buf = vim.lsp.buf
          lspkey("gD", buf.declaration, "Go to declaration", event)
          lspkey("gd", utils.config.lsp_definition_centered(), "Go to definition (centered)", event)
          lspkey("gi", buf.implementation, "Go to implementation", event)
          lspkey("go", buf.type_definition, "Go to type definition (origin)", event)
          lspkey("gr", buf.references, "View references", event)
          lspkey("gs", buf.signature_help, "Function/Signature hover info", event)
          lspkey("<F1>", vim.diagnostic.open_float, "Open float info", event)
          lspkey("<F2>", buf.rename, "Rename object", event)
          -- <F3> (format current buffer) is handled by Conform
          lspkey("<F4>", buf.code_action, "Code action", event)
          lspkey("<leader>gq", vim.diagnostic.setloclist, "Set loclist", event)
          lspkey("<leader>td", toggle_lsp_diag, "Toggle diagnostics", event)
        end,
      })

      -------------------------------------------------------------------------

      --- Servers configurations (`:h lspconfig-configurations`)
      local servers_configs = {
        ansiblels = {},
        clangd = {
          cmd = { "clangd", "--fallback-style=WebKit" },
        },
        cssls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        marksman = {},
        pylsp = {
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
        },
        texlab = {
          settings = {
            texlab = {
              rootDirectory = ".",
              latexFormatter = "texlab",
            },
          },
        },
        tsserver = { enabled = false },
        vtsls = {
          settings = {
            complete_function_calls = true,
          },
          typescript = {
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      }

      -- Add cmp capabilities to nvim defaults
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Apply servers configurations
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            server_name = server_name == "tsserver" and "ts_ls" or server_name
            local server = servers_configs[server_name] or {}
            server.capabilities =
              vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -------------------------------------------------------------------------

      -- Add borders to LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- Add borders to Hover when Noice is not in the Lazy plugins spec.
      if not require("lazy.core.config").spec.plugins["noice.nvim"] then
        vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      end

      -- Disable log
      vim.lsp.set_log_level(vim.lsp.log_levels.OFF)
    end,
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
        "lua-language-server", -- Lua language server
        "marksman", -- Markdown language server
        "markdown-toc", -- Markdown TOC generator (under tag: `<!-- toc -->`)
        "prettier", -- Formatter for css, html, json, javascript, yaml and more.
        "python-lsp-server", -- Fork of python-language-server
        "shfmt", -- Bash/sh formatter
        "stylua", -- Lua formatter
        "texlab", -- LaTeX language server
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
  --- Snippets
  {
    "L3MON4D3/LuaSnip",
    opts = {
      enable_autosnippets = false,
      -- Don't jump into snippets that have been left
      delete_check_events = "TextChanged,InsertLeave",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      local ls = require("luasnip")

      -- Add custom snippets
      local custom_snips = NeovimPath .. "/lua/snippets/"
      require("luasnip.loaders.from_lua").load({ paths = { custom_snips } })

      -- Add virtual marks on inputs
      local types = require("luasnip.util.types")
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
  --- Telescope: Searches with fzf
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        enabled = vim.fn.executable("sqlite3") == 1,
        init = function()
          utils.autocmd.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("smart_history") end
          )
        end,
      },

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        init = function()
          utils.autocmd.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("fzf") end
          )
        end,
      },
      {
        "polirritmico/telescope-lazy-plugins.nvim",
        dev = false,
        init = function()
          utils.autocmd.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("lazy_plugins") end
          )
        end,
      },
    },
    -- stylua: ignore
    keys = {
      -- Builtins
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope: Find files (nvim runtime path)" },
      { "<leader>fF", "<Cmd>Telescope find_files cwd=%:p:h hidden=true prompt_title=Find\\ Files\\ (cwd\\ from\\ file)<CR>", desc = "Telescope: Find files (from file path)" },
      { "<leader>fb", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Telescope: Find/Switch between buffers" },
      { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope: Find grep" },
      { "<leader>fG", "<Cmd>Telescope live_grep cwd=%:p:h prompt_title=Live\\ Grep\\ (cwd\\ from\\ file)<CR>", desc = "Telescope: Find grep (from buffer path)" },
      { "<leader>fg", "<Cmd>Telescope grep_string<CR>", mode = "x", desc = "Telescope: Find Grep (selected string)" },
      { "<leader>fr", "<Cmd>Telescope registers<CR>", mode = { "n", "v" }, desc = "Telescope: Select and paste from registers" },
      { "<leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Telescope: Find recent/old files" },
      { "<leader>fl", "<Cmd>Telescope resume<CR>", desc = "Telescope: List results of the last telescope search" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope: Find in help tags" },
      { "<leader>fm", "<Cmd>Telescope marks<CR>", desc = "Telescope: Find buffer marks" },
      { "<leader>fT", "<Cmd>Telescope<CR>", desc = "Telescope: Find telescope builtins functions" },
      { "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Telescope: Find symbols" },
      { "<leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Telescope: Find workspace symbols" },
      { "<leader>fw", "<Cmd>Telescope current_buffer_fuzzy_find<CR>",desc = "Telescope: Find word (like `/`)" },
      { "zf", utils.plugins.telescope_spell_suggest, desc = "Telescope: Find spell word suggestion" },

      -- Configs
      { "<leader>cs", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/lua/snippets/"<CR>]], desc = "Telescope: Snippets sources" },
      { "<leader>ct", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/after/ftplugin/"<CR>]], desc = "Telescope: Filetypes configurations" },
      { "<leader>cc", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath<CR>]], desc = "Telescope: Plugins configurations" },
      { "<leader>cu", [[<Cmd>execute "Telescope live_grep cwd=".NeovimPath."/lua/utils/ prompt_title=Find\\ Utils"<CR>]], desc = "Telescope: Utils" },
      { "<leader>cp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope: Config plugins" },

      -- Custom
      { "<leader>fn", utils.custom.scratchs, desc = "Telescope: Open or create a new scratch buffer" },
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
        "%.webm", "%.mp4", "%.mkv",
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
              ["<CR>"] = utils.plugins.telescope_open_single_or_multi,
              ["<C-q>"] = utils.plugins.telescope_open_and_fill_qflist,
              ["<C-f>"] = utils.plugins.telescope_narrow_matches,
              ["<C-h>"] = "which_key", -- show/hide keymaps help
              ["<ESC>"] = "close",
              ["<LeftMouse>"] = function() end,
            },
          },
        },
        pickers = {
          buffers = { mappings = { ["i"] = { ["<C-c>"] = "delete_buffer" } } },
          find_files = { follow = true },
          live_grep = { additional_args = { "--follow" } },
          grep_string = { additional_args = { "--follow" } },
        },
        extensions = {
          lazy_plugins = {
            custom_entries = (function()
              local path = NeovimPath .. "/lua/plugins/"
              return {
                { name = "Core", filepath = path .. "core.lua" },
                { name = "Develop", filepath = path .. "develop.lua" },
                { name = "Extras", filepath = path .. "extras/spec.lua" },
                { name = "Helpers", filepath = path .. "helpers.lua" },
                { name = "Misc", filepath = path .. "misc.lua" },
                { name = "UI", filepath = path .. "ui.lua" },
              }
            end)(),
          },
        },
      }
    end,
  },
  --- Treesitter: Parse program langs for highlights, indent, conceals, etc.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
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
  },
}
