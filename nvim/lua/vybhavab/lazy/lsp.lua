return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mfussenegger/nvim-lint',
    'mhartington/formatter.nvim',
    "onsails/lspkind.nvim",
    'saghen/blink.cmp',
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap',
    'j-hui/fidget.nvim',
  },
  config = function ()
    require("fidget").setup({})

    local lsp_servers = { 'tsgo', 'lua_ls', 'gopls', 'bashls', 'rust_analyzer', 'clangd', 'html', 'cssls', 'tailwindcss' }

    vim.lsp.enable(lsp_servers)

    vim.diagnostic.config({
      update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      }
    })

    local util = require "formatter.util"
    if require("vybhavab.utils.nodePackageReader").check_xo_dependency() then
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          javascript = {
            function()
              return {
                exe = "xo",
                args = {"--fix", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
                stdin = true
              }
            end
          },
          javascriptreact = {
            function()
              return {
                exe = "xo",
                args = {"--fix", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
                stdin = true
              }
            end
          },
          typescript = {
            function()
              return {
                exe = "xo",
                args = {"--fix", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
                stdin = true
              }
            end
          },
          typescriptreact = {
            function()
              return {
                exe = "xo",
                args = {"--fix", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
                stdin = true
              }
            end
          },
          lua = {
            require("formatter.filetypes.lua").stylua,
            function()
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace
          }
        }
      })
    else
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          javascript = {
            require("formatter.filetypes.javascript").prettierd,
            require("formatter.filetypes.javascript").eslint_d,
          },
          javascriptreact = {
            require("formatter.filetypes.javascriptreact").prettierd,
            require("formatter.filetypes.javascriptreact").eslint_d,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettierd,
            require("formatter.filetypes.typescript").eslint_d,
          },
          typescriptreact = {
            require("formatter.filetypes.typescriptreact").prettierd,
            require("formatter.filetypes.typescriptreact").eslint_d,
          },
          lua = {
            require("formatter.filetypes.lua").stylua,
            function()
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace
          }
        }
      })

      require('lint').linters_by_ft = {
        javascript = {'eslint_d'},
        javascriptreact = {'eslint_d'},
        typescript = {'eslint_d'},
        typescriptreact = {'eslint_d'},
      }
    end
  end
}
