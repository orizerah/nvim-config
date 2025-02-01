local js_based_languages = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

return {
  { 'nvim-neotest/nvim-nio' },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      if LazyVim.has 'mason-nvim-dap.nvim' then
        require('mason-nvim-dap').setup(LazyVim.opts 'mason-nvim-dap.nvim')
      end

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
      end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch & Debug Chrome',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = 'Enter URL: ',
                  default = 'http://localhost:3000',
                }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = 'inspector',
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = '----- ↓ launch.json configs ↓ -----',
            type = '',
            request = 'launch',
          },
        }
      end
    end,
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result.',
      },
      {
        '<leader>da',
        function()
          if vim.fn.filereadable '.vscode/launch.json' then
            local dap_vscode = require 'dap.ext.vscode'
            dap_vscode.load_launchjs(nil, {
              ['pwa-node'] = js_based_languages,
              ['chrome'] = js_based_languages,
              ['pwa-chrome'] = js_based_languages,
            })
          end
          require('dap').continue()
        end,
        desc = 'Run with Args',
      },
    },
    dependencies = {
      { 'LazyVim/LazyVim' },
      {
        'microsoft/vscode-js-debug',
        -- After install, build it and rename the dist directory to out
        build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
        version = '1.*',
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('dap-vscode-js').setup {
            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- node_path = "node",

            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug'),

            -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
            -- debugger_cmd = { "js-debug-adapter" },

            -- which adapters to register in nvim-dap
            adapters = {
              'chrome',
              'pwa-node',
              'pwa-chrome',
              'pwa-msedge',
              'pwa-extensionHost',
              'node-terminal',
            },

            -- Path for file logging
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

            -- Logging level for output to file. Set to false to disable logging.
            -- log_file_level = false,

            -- Logging level for output to console. Set to false to disable console output.
            -- log_console_level = vim.log.levels.ERROR,
          }
        end,
      },
      {
        'Joakker/lua-json5',
        build = './install.sh',
      },
    },
  },
  {
    'leoluz/nvim-dap-go',
    config = function()
      require('dap-go').setup {
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
          {
            type = 'go',
            name = 'Attach remote',
            mode = 'remote',
            request = 'attach',
          },
        },
        -- delve configurations
        delve = {
          path = 'dlv',
          initialize_timeout_sec = 20,
          port = '${port}',
          args = {},
          build_flags = {},
          detached = vim.fn.has 'win32' == 0,
          cwd = nil,
        },
        tests = {
          verbose = false,
        },
      }
    end,
    dependencies = {
      'mfussenegger/nvim-dap',
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    config = function()
      require('dapui').setup()
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    config = function()
      require('persistent-breakpoints').setup {
        save_dir = vim.fn.stdpath 'data' .. '/nvim_checkpoints',
        load_breakpoints_event = nil,
        perf_record = false,
        on_load_breakpoint = nil,
      }
    end,
  },
}
