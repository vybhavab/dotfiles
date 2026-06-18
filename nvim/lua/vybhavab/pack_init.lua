local function gh(repo)
  return "https://github.com/" .. repo
end

local function pack_path(name)
  local plugins = vim.pack.get({ name }, { info = false })
  return plugins[1] and plugins[1].path or (vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. name)
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("VybhavABPackHooks", { clear = true }),
  callback = function(event)
    local data = event.data
    if not data or data.spec.name ~= "vscode-js-debug" then
      return
    end

    if data.kind ~= "install" and data.kind ~= "update" then
      return
    end

    local install = vim.system(
      { "npm", "install", "--legacy-peer-deps", "--ignore-scripts" },
      { cwd = data.path }
    ):wait()

    if install.code ~= 0 then
      vim.notify("vscode-js-debug npm install failed", vim.log.levels.ERROR)
      return
    end

    local compile = vim.system({ "npx", "gulp", "vsDebugServerBundle" }, { cwd = data.path }):wait()
    if compile.code ~= 0 then
      vim.notify("vscode-js-debug compile failed", vim.log.levels.ERROR)
    end
  end,
})

vim.pack.add({
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-neotest/nvim-nio"),
  gh("nvim-mini/mini.nvim"),
  gh("rafamadriz/friendly-snippets"),
  gh("onsails/lspkind.nvim"),
  gh("mbbill/undotree"),
  gh("folke/zen-mode.nvim"),
  gh("tpope/vim-fugitive"),
  gh("ThePrimeagen/git-worktree.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("dmmulroy/ts-error-translator.nvim"),
  gh("stevearc/conform.nvim"),
  gh("folke/tokyonight.nvim"),
  gh("nvim-telescope/telescope.nvim"),
  gh("neovim/nvim-lspconfig"),
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
  gh("j-hui/fidget.nvim"),
  gh("folke/snacks.nvim"),
  gh("folke/trouble.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/sidekick.nvim"),
  gh("supermaven-inc/supermaven-nvim"),
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  { src = gh("microsoft/vscode-js-debug"), version = "main" },
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("folke/which-key.nvim"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
}, { confirm = false, load = true })

vim.g.tokyonight_style = "night"
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"
vim.cmd.colorscheme("tokyonight")

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("SignColumn", { bg = "none" })
hl("ColorColumn", { ctermbg = 0, bg = "#2B79A0" })
hl("CursorLineNR", { bg = "None" })
hl("Normal", { bg = "none" })
hl("NormalFloat", { bg = "none" })
hl("NormalNC", { bg = "none" })
hl("TelescopePromptPrefix", { fg = "#5eacd3", bg = "none", bold = true })
hl("LineNr", { fg = "#5eacd3" })
hl("netrwDir", { fg = "#5eacd3" })

require("gitsigns").setup({
  current_line_blame = true,
})

vim.keymap.set("n", "<F9>", ":UndotreeToggle<CR>")
require("ts-error-translator").setup()
require("fidget").setup({})

require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    suffix_last = "",
    suffix_next = "",
  },
  search_method = "cover_or_next",
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    json = { "biome", "prettierd", "prettier", stop_after_first = true },
    jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    sh = { "shfmt" },
    zsh = { "shfmt" },
    go = { "gofmt" },
    rust = { "rustfmt", lsp_format = "fallback" },
    python = { "isort", "black" },
  },
  default_format_opts = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") then
      return
    end

    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

require("render-markdown").setup({
  file_types = { "markdown" },
})

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = { documentation = { auto_show = true } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

local lspconfig_configs = require("lspconfig.configs")
local lsp_servers = {
  "tsgo",
  "lua_ls",
  "gopls",
  "bashls",
  "rust_analyzer",
  "clangd",
  "html",
  "cssls",
  "tailwindcss",
  "eslint",
  "biome",
  "basedpyright",
  "jsonls",
}

for _, server in ipairs(lsp_servers) do
  local config_path = "vybhavab.lsp." .. server
  local ok, custom_config = pcall(require, config_path)
  if ok then
    local merged = custom_config
    local has_builtin = pcall(require, "lspconfig.configs." .. server)
    local defaults = has_builtin
        and lspconfig_configs[server]
        and lspconfig_configs[server].document_config
        and lspconfig_configs[server].document_config.default_config

    if defaults then
      merged = vim.tbl_deep_extend("force", vim.deepcopy(defaults), custom_config)
    end

    vim.lsp.config(server, merged)
  end
end

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
  },
})

local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, {})
vim.keymap.set("n", "<C-p>", function()
  telescope_builtin.git_files({
    cwd = vim.uv.cwd(),
    use_git_root = false,
    recurse_submodules = true,
  })
end, {})
vim.keymap.set("n", "<leader>ps", function()
  telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>pws", function()
  telescope_builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set("n", "<leader>pWs", function()
  telescope_builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
end)
vim.keymap.set("n", "<leader>pg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>ht", telescope_builtin.help_tags, {})

pcall(telescope.load_extension, "git_worktree")
vim.keymap.set("n", "<leader>gw", function()
  telescope.extensions.git_worktree.git_worktrees()
end)
vim.keymap.set("n", "<leader>gW", function()
  telescope.extensions.git_worktree.create_git_worktree()
end)

require("snacks").setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  lazygit = { enabled = true },
  terminal = { enabled = true },
  gitbrowse = { enabled = true },
  indent = { enabled = true },
  zen = { enabled = true },
  rename = { enabled = true },
})

vim.keymap.set("n", "<c-y>", function() require("snacks").lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gg", function() require("snacks").lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gf", function() require("snacks").lazygit.log_file() end, { desc = "Lazygit Current File" })
vim.keymap.set("n", "<leader>gb", function() require("snacks").gitbrowse() end, { desc = "Git Browse" })
vim.keymap.set("n", "<c-/>", function() require("snacks").terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>z", function() require("snacks").zen() end, { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>Z", function() require("snacks").zen.zoom() end, { desc = "Toggle Zoom" })

require("trouble").setup({})
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "palenight",
    component_separators = { "", "" },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

require("sidekick").setup({
  cli = {
    mux = {
      backend = "tmux",
      enabled = false,
    },
  },
})

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle" })
vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function() require("sidekick.cli").select() end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach a CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Sidekick Select Prompt" })
vim.keymap.set("n", "<leader>ao", function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end, { desc = "Sidekick Toggle OpenCode" })
vim.keymap.set("n", "<leader>ac", function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end, { desc = "Sidekick Toggle Codex" })

require("supermaven-nvim").setup({})

local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local dap_utils = require("dap.utils")

dapui.setup({
  floating = { border = "rounded" },
  layouts = {
    { elements = { "scopes", "watches" }, size = 40, position = "left" },
    { elements = { "repl", "breakpoints" }, size = 12, position = "bottom" },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local js_debug_server = pack_path("vscode-js-debug") .. "/dist/src/vsDebugServer.js"
for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
  dap.adapters[adapter] = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "node",
      args = { js_debug_server, "${port}" },
    },
  }
end

for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file (Node)",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Next.js server",
      processId = dap_utils.pick_process,
      cwd = "${workspaceFolder}",
      skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Chrome for Next.js",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      userDataDir = false,
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach Chrome (9222)",
      port = 9222,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
  }
end

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

map("<F5>", dap.continue, "DAP continue")
map("<F10>", dap.step_over, "DAP step over")
map("<F11>", dap.step_into, "DAP step into")
map("<F12>", dap.step_out, "DAP step out")
map("<leader>db", dap.toggle_breakpoint, "DAP toggle breakpoint")
map("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "DAP conditional breakpoint")
map("<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "DAP log point")
map("<leader>dr", dap.repl.open, "DAP open REPL")
map("<leader>du", dapui.toggle, "Toggle DAP UI")
map("<leader>ds", function()
  widgets.centered_float(widgets.scopes)
end, "DAP scopes")

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
  },
  win = {
    border = "rounded",
  },
  spec = {
    { "<leader>v", group = "LSP" },
    { "<leader>p", group = "Project" },
    { "<leader>t", group = "Tabs" },
  },
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps" })
