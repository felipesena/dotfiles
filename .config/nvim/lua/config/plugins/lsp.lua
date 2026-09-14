return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
      },
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim",       opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
        end,
      })

      local servers = {
        kotlin_language_server = {},
        pyright = {},
        gopls = {},
        yamlls = {},
        taplo = {
          settings = {
            evenBetterToml = {
              formatter = {
                indentTables = true,
                indentEntries = false,
                alignEntries = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      }

      local formatters = {
        "stylua",
        "ktlint",
      }

      -- Not lspconfig servers: started manually (jdtls, via after/ftplugin/java.lua)
      -- or wired as nvim-dap adapters (java-debug-adapter, java-test, kotlin-debug-adapter).
      local debug_tools = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "kotlin-debug-adapter",
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, formatters)
      vim.list_extend(ensure_installed, debug_tools)

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- Apply per-server config. mason-lspconfig (v2) enables installed servers
      -- automatically via vim.lsp.enable(); we just feed them their settings.
      for server_name, server in pairs(servers) do
        vim.lsp.config(server_name, server)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
    end,
  },
}
