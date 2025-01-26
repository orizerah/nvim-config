return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      local startify = require 'alpha.themes.startify'
      startify.file_icons.provider = 'devicons'
      alpha.setup(startify.config)
      dashboard.section.header.val = {
        '                             ',
        '  ██████╗ ██████╗ ██╗███████╗',
        ' ██╔═══██╗██╔══██╗██║╚══███╔╝',
        ' ██║   ██║██████╔╝██║  ███╔╝ ',
        ' ██║   ██║██╔══██╗██║ ███╔╝  ',
        ' ╚██████╔╝██║  ██║██║███████╗',
        '  ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝',
        '                             ',
      }
      dashboard.section.buttons.val = {
        dashboard.button('f', '  > File Browser', '<leader>fb'),
        dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
        dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>'),
        dashboard.button('q', '  > Quit NVIM', ':qa<CR>'),
      }
      alpha.setup(dashboard.opts)
    end,
  },
}
