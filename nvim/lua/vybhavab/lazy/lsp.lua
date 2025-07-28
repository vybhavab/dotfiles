local function start_tsgo()
    local root_files = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
    local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
    local root_dir = vim.fs.dirname(paths[1])

    if root_dir == nil then
        -- root directory was not found
        return
    end

    vim.lsp.start({
        name = "tsgo",
        cmd = { "~/.local/bin/tsgo", "lsp", "--stdio" },
        root_dir = root_dir,
        -- init_options = { hostInfo = "neovim" }, -- not implemented yet
    })
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-lint',
      'mhartington/formatter.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap',
      'j-hui/fidget.nvim',
      "supermaven-inc/supermaven-nvim",
      "onsails/lspkind.nvim",
    },
    config = function ()
      require("fidget").setup({})
      require('mason').setup()

      local cmp_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
      )

      require("mason-lspconfig").setup({
        ensure_installed = {
					'bashls',
					'clangd',
					'cmake',
					'cssls',
					'eslint',
					'golangci_lint_ls',
					'gopls',
					'html',
					'lua_ls',
					'prismals',
					'rust_analyzer',
					'tailwindcss',
					'thriftls',
					'ts_ls',
        },
        handlers = {
           function (server_name)
             require("lspconfig")[server_name].setup({
               capabilities = capabilities,
             })
           end,
           ["lua_ls"] = function ()
               local lspconfig = require("lspconfig")
               lspconfig.lua_ls.setup {
                   capabilities = capabilities,
                   settings = {
                       Lua = {
                           workspace = {
                             checkThirdParty = false,
                           },
                           diagnostics = {
                               globals = { "vim" }
                           }
                       }
                   }
               }
           end,
        }
      })

      local cmp = require('cmp')
      local cmp_select = {behavior = cmp.SelectBehavior.Select}
      local lspkind = require('lspkind')


      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<CR>'] = cmp.mapping.confirm({ behavior= cmp.ConfirmBehavior.Replace, select = false }),
          ['<C-y>'] = cmp.mapping.confirm({ behavior= cmp.ConfirmBehavior.Replace, select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'supermaven' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = {
              menu = 50,
              abbr = 50,
            },
            symbol_map = {
              Supermaven = "",
            },
            ellipsis_char = '...',
            show_labelDetails = true,
            before = function (entry, vim_item)
              return vim_item
            end
          })
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

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
}
