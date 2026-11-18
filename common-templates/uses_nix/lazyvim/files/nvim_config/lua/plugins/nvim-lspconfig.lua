return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      require("lspconfig").mojo.setup({ cmd = { "mojo-lsp-server", "-I", "." } })

      -- Format on save using LSP
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.mojo",
        callback = function()
          -- Check for an active 'mojo' LSP client that supports formatting
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "mojo" })
          if #clients > 0 and clients[1].supports_method("textDocument/formatting") then
            -- Trigger formatting synchronously before the buffer is written
            vim.lsp.buf.format({ async = false })
          end
        end,
      })
    end,
  },
}
