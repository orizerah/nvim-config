return {
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }

      vim.keymap.set('n', '<leader>`', '<cmd>HopWord<cr>', { desc = '[H]op word' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
