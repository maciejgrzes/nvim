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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- theme
    { "Mofiqul/dracula.nvim" },
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

    -- nvim-lspconfig (robust for both new and old APIs)
    {
    "neovim/nvim-lspconfig",
    config = function()
      -- Attempt to get cmp capabilities if cmp_nvim_lsp is available
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local default_capabilities = nil
      if cmp_ok and cmp_nvim_lsp and type(cmp_nvim_lsp.default_capabilities) == "function" then
        default_capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
      end

      local function merge_opts(opts)
        opts = opts or {}
        if default_capabilities then
          -- merge capabilities into opts, don't overwrite if already present
          opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, default_capabilities)
        end
        return opts
      end

      local function setup_server(name, opts)
        opts = merge_opts(opts)

        -- Try new API: vim.lsp.config[name](opts)
        local ok_new, _ = pcall(function()
          if vim.lsp and vim.lsp.config and type(vim.lsp.config[name]) == "function" then
            vim.lsp.config[name](opts)
            return true
          end
        end)
        if ok_new then return end

        -- Fallback to old lspconfig: require("lspconfig")[name].setup(opts)
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

      -- Example server configs
      setup_server("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

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

      setup_server("clangd", {})
    end,
    },

    -- Autocompletion
    {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",             -- Snippet engine
      "saadparwaiz1/cmp_luasnip",     -- Snippet completion
      "hrsh7th/cmp-buffer",           -- Buffer words
      "hrsh7th/cmp-path",             -- File paths
      "rafamadriz/friendly-snippets", -- Predefined snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
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

    -- mini indentscope
    {
      "nvim-mini/mini.indentscope",
      version = false,
      opts = {
        symbol = "│",
        options = { try_as_border = true },
      },
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "help", "alpha", "dashboard", "neo-tree", "toggleterm" },
          callback = function()
            vim.b.miniindentscope_disable = true
          end,
        })
      end,
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
})
