return {
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.keymap.set('n', '<leader>tp', '<cmd>FloatermToggle --name=term<cr>')
    end,
  },
}
