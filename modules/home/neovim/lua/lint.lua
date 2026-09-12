local lint = require 'lint'

lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  vue = { 'eslint_d' },
  python = { 'ruff' },
  c = { 'cpplint' },
  cpp = { 'cpplint' },
  sh = { 'shellcheck' },
  nix = { 'statix' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'BufEnter' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.filetype == '' or vim.api.nvim_buf_line_count(0) > 5000 then
      return
    end
    require('lint').try_lint()
  end,
})
