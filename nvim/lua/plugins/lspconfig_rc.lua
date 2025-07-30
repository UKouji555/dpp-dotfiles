local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})
--lspconfig.ts_ls.setup {
--  settings = {
--  },
--}

--lspconfig.kotlin_language_server.setup {
--  settings = { "kotlin_language_server" },
--}

lspconfig.efm.setup({
  init_options = { documentFormatting = true },
  filetypes = { "go", "lua", "typescript", "javascript", "typescriptreact", "javascriptreact" },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      lua = {
        { formatCommand = "stylua -g '*.lua' -g '!*.spec.lua' -- .", formatStdin = true },
      },
      typescript = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      javascript = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      typescriptreact = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      javascriptreact = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      go = {
        { formatCommand = "gofmt", formatStdin = true },
      },
      --      kotlin = {
      --        { formatCommand = "ktlint --format", formatStdin = true }
      --      },
    },
  },
})
