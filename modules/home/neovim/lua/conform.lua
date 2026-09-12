require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = {}
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 5000,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },

    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },

    vue = { 'prettierd', 'prettier', stop_after_first = true },

    css = { 'prettierd', 'prettier', stop_after_first = true },
    scss = { 'prettierd', 'prettier', stop_after_first = true },
    less = { 'prettierd', 'prettier', stop_after_first = true },

    html = { 'prettierd', 'prettier', stop_after_first = true },

    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },

    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    yml = { 'prettierd', 'prettier', stop_after_first = true },

    markdown = { 'prettierd', 'prettier', stop_after_first = true },

    python = { 'ruff_format', 'ruff_organize_imports' },

    c = { 'clang_format' },
    cpp = { 'clang_format' },

    toml = { 'taplo' },

    sh = { 'shfmt' },

    nix = { 'alejandra' },
  },
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
