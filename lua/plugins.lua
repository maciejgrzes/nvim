local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.termguicolors = true
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- theme
    { "Mofiqul/dracula.nvim" },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}, },
    -- auto ()
    { "windwp/nvim-autopairs", config = true },

    -- LSP manager
    {
    "williamboman/mason.nvim",
    config = true,
    },
    {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
    },

    -- nvim-lspconfig
    {
      "neovim/nvim-lspconfig",
      dependencies = { "saghen/blink.cmp" },
      config = function()
        local blink_ok, blink = pcall(require, "blink.cmp")
        local default_capabilities = nil

        if blink_ok and blink and blink.get_lsp_capabilities then
          default_capabilities =
            blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
        end

        local function merge_opts(opts)
          opts = opts or {}
          if default_capabilities then
            opts.capabilities =
              vim.tbl_deep_extend("force", opts.capabilities or {}, default_capabilities)
          end

          local user_on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            if user_on_attach then user_on_attach(client, bufnr) end

            -- Start semantic tokens if supported
            if client.server_capabilities.semanticTokensProvider then
              pcall(vim.lsp.semantic_tokens.start, bufnr, client.id)
            end
          end

          return opts
        end

        local function setup_server(name, opts)
          opts = merge_opts(opts)

          local ok_new, _ = pcall(function()
            if vim.lsp and vim.lsp.config and type(vim.lsp.config[name]) == "function" then
              vim.lsp.config[name](opts)
              return true
            end
          end)
          if ok_new then return end

          local ok_old, lspconfig = pcall(require, "lspconfig")
          if ok_old and lspconfig[name] and type(lspconfig[name].setup) == "function" then
            lspconfig[name].setup(opts)
            return
          end

          vim.notify(string.format(
            "[lsp-config] failed to configure %s: new API present=%s, lspconfig present=%s",
            name,
            tostring(vim.lsp and vim.lsp.config and type(vim.lsp.config[name]) == "function"),
            tostring(ok_old)
          ), vim.log.levels.WARN)
        end

        -- Highlight links for semantic tokens
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            vim.api.nvim_set_hl(0, "@lsp.type.parameter.cpp", { link = "@variable.parameter" })
            vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary.cpp", { link = "@variable.builtin" })
            vim.api.nvim_set_hl(0, "@lsp.type.class.cpp", { link = "@type" })
            vim.api.nvim_set_hl(0, "@lsp.type.namespace.cpp", { link = "@namespace" })
          end,
        })

        -- Servers
        -- LUA
        setup_server("lua_ls", {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        })
        -- PYTHON
        setup_server("pylsp", {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = true },
                pycodestyle = { enabled = false },
              },
            },
          },
        })
        -- C/C++
        setup_server("clangd", {
          cmd = { "clangd" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          init_options = { clangdFileStatus = true, semanticHighlighting = true },
        })

        -- HTML
        setup_server("html", {
          filetypes = { "html" },
          init_options = {
            provideFormatter = true,
          },
        })

        -- CSS
        setup_server("cssls", {
          filetypes = { "css", "scss", "less" },
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        })

        -- JavaScript / TypeScript
        setup_server("ts_ls", {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
          end,
          settings = {
            typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
            javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
          },
        })

        -- JAVA
        setup_server("jdtls", {
          filetypes = { "java" },
          cmd = { "jdtls" },
          root_dir = require("lspconfig.util").root_pattern("pom.xml", "build.gradle", ".git"),
        })

        -- JSON
        setup_server("jsonls", {
          filetypes = { "json", "jsonc" },
          cmd = { "vscode-json-languageserver", "--stdio" },
          root_dir = require("lspconfig.util").root_pattern(".git"),
        })
      end,
    },


    -- Autocompletion
    {
    'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        opts = {
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            keymap = { preset = 'super-tab' },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            signature = { enabled = true }
        }
    },

    -- nvim-treesitter
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "python" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
    },

    -- statusline
    {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "dracula",
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
    end,
    },

    -- indent blankline
    {
    "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        setup = function()
            vim.g.indentLine_enabled = 1
            vim.g.indent_blankline_char = "▏"
            vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard" }
            vim.g.indent_blankline_buftype_exclude = { "terminal" }
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.g.indent_blankline_show_first_indent_level = false
            vim.g.indent_blankline_show_current_context = true
            vim.g.indent_blankline_show_current_context_start = true
        end
    },

    -- which-key
    {
      "folke/which-key.nvim",
        opts = {
        timeout = true,
        win = { border = "single" }
      },
      config = function(_, opts)require("which-key").setup(opts)end,
    },
    { "echasnovski/mini.icons", version = false },

    -- comments
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },

    -- file explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
          filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
            follow_current_file = true,
            hijack_netrw_behavior = "open_default",
          },
        })

        vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
      end,
    },

    -- tabs
    {
      "akinsho/bufferline.nvim",
      tag = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            numbers = "none",
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            indicator = { style = "underline" },
            buffer_close_icon = "",
            modified_icon = "●",
            show_close_icon = false,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            separator_style = "slant",
            diagnostics = "nvim_lsp",
            
            offsets = {
              {
                filetype = "neo-tree",
                text = "Explorer",
                highlight = "Directory",
                text_align = "left",
              },
            },
          },
        })
      end,
    },
})
