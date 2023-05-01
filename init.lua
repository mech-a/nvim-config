-- Avoid Race Conditions with NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key mapped to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Setup
require('lazy').setup({
  -- Git related plugins
  { 'tpope/vim-fugitive', lazy=true, },
  { 'tpope/vim-rhubarb', lazy=true, },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = {}, },

  { -- Allow for jk/kj/jj escaping more cleanly 
    'nvim-zh/better-escape.vim',
    config = function()
      vim.go.better_escape_shortcut = 'jk'
    end,
  },

  { -- Very fast movement 
    -- s__ for forward, S__ for backwards, and gs__ for diff windows
    -- TODO: setup tokyonight highlight colors, can't see very well
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      require('leap').add_default_mappings()
    end
  },

  { -- More sensible word movement
    -- TODO: doesn't work
    'chrisgrieser/nvim-spider',
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { -- Tree-view of LSP symbols
    'simrat39/symbols-outline.nvim',
    opts = {},
  },

  { -- Rust Tooling
    'simrat39/rust-tools.nvim'
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- TODO: understand what snippets are and which engines are there
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'onsails/lspkind.nvim' },
  },

  { -- Autopairs // TODO: add <>
    'windwp/nvim-autopairs',
    dependencies='hrsh7th/nvim-cmp',
    opts={},
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Excellent theme
    'folke/tokyonight.nvim',
    enabled=false,
    priority=1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { -- Alternate theme
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        term_colors=true,
        dim_inactive = {
          enabled=true,
        }
      })
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        -- icons_enabled = false,
        theme = 'auto',
        disabled_filetypes = { 'lazy', 'NvimTree', },
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  { -- Buffer line 
    'akinsho/bufferline.nvim',
    -- tag = 'v3.5.0',
    version = 'v3',
    opts = {
      options = {
        -- separator_style = 'slant',
        diagnostics = "nvim_lsp",
      },
    },
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      -- char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  { -- Todo, Note, Fix, Warning, Perf, Hack highlighting 
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} }, -- TODO: do insert mappings for commenting

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', tag='0.1.1', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  { -- Quick documentation
    'danymat/neogen',
    lazy=true,
    dependencies='nvim-treesitter/nvim-treesitter',
    config = function()
      require('neogen').setup({
        snippet_engine='luasnip',
      })
      vim.keymap.set('n', '<leader>d', require('neogen').generate, { desc='Generate [d]ocumentation' })
    end
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Edit Mappings
vim.keymap.set('n', '0', '^') -- First non-space character is now 0, first character is now ^
vim.keymap.set('n', '^', '0')

-- Set highlight on search to false
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode to act as all
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Colors
vim.o.termguicolors = true

-- Better indenting
vim.o.smartindent = true -- Autoindent is true by default
vim.o.wrap = true

-- UI
vim.o.scrolloff = 7         -- Set 7 lines to the cursor - when moving vertically using j/k
vim.o.cmdheight = 1         -- Height of the command bar
vim.o.lazyredraw = true     -- Don't redraw while executing macros (performance)

-- For creating most keybinds
local wk = require('which-key')

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

wk.register({
  -- NvimTree
  ["<Leader>e"] = {"<cmd>NvimTreeToggle<cr>", "Toggle file [e]xplorer"},
  -- Meta
  ["<Leader>q"] = {"<cmd>e $MYVIMRC<cr>", "Edit nvim conf"},
  -- Window Movement
  ["<Leader>h"] = {"<C-W>h", "Move to left window"},
  ["<Leader>j"] = {"<C-W>j", "Move down"},
  ["<Leader>k"] = {"<C-W>k", "Move up"},
  ["<Leader>l"] = {"<C-W>l", "Move right"},
})


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')


local tb = require('telescope.builtin')
wk.register({
  ["?"] = { tb.oldfiles, "Find recently opened files" },
  ["/"] = { function()
   tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
    end, "Search in current buffer",
  },

  s = {
    name = "+Search",
    f = { tb.find_files, "Search [f]iles" },
    b = { tb.buffers, "Search for [b]uffer" },
    h = { tb.help_tags, "Search nvim [h]elp" },
    w = { tb.grep_string, "Search current [w]ord" },
    g = { tb.live_grep, "Search by live [g]rep" },
    x = { tb.diagnostics, "Search LSP diagnostics" },
    t = { "<cmd>TodoTelescope keywords=TODO,fix<cr>", "Search [t]odos"},
  },
}, { prefix = "<leader>" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim' },

  -- Autoinstall languages that are not installed 
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>x', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>X', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  wk.register({
    ["<leader>rn"] = { vim.lsp.buf.rename, "LSP: [R]e[n]ame object" },
    ["<leader>ca"] = { vim.lsp.buf.code_action, "LSP: [C]ode [A]ction" },
    ["<leader>sr"] = { tb.lsp_references, "LSP: Search under-cursor [r]eferences" },
    ["<leader>sd"] = { tb.lsp_document_symbols, "LSP: Search [d]ocument symbols" },
    ["<leader>sw"] = { tb.lsp_dynamic_workspace_symbols, "LSP: Search [w]orkspace symbols" },
    ["<leader>y"]  = { "<cmd>SymbolsOutline<cr>", "LSP: Toggle s[y]mbol tree" },
    ["<leader>D"]  = { vim.lsp.buf.type_definition, "LSP: Type [D]efinition" },
    g = {
      d = { vim.lsp.buf.definition, 'LSP: Goto [d]efinition' },
      i = { vim.lsp.buf.implementation, 'LSP: Goto [i]mplementation' },
      D = { vim.lsp.buf.declaration, 'LSP: Goto [D}eclaration' },
    },
    ["<leader>w"] = {
      name = "+LSP: Workspace",
      a = { vim.lsp.buf.add_workspace_folder, "LSP: Workspace [a]dd folder" },
      r = { vim.lsp.buf.remove_workspace_folder, "LSP: Workspace [r]emove folder" },
      l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP: Workspace [l]ist folders" },
    },

  }, {buffer = bufnr})

  wk.register({
    [" "] = { tb.lsp_document_symbols, "LSP: Search document symbols" },
  }, {prefix="<leader>"})

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Seperate Rust Tools 
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      on_attach(_, bufnr)
      -- Hover actions TODO: overlapping with treesitter and maybe cmp?
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups TODO: overlapping with treesitter
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    capabilities=capabilities,
  },
})

-- nvim-cmp setup
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

luasnip.config.setup {}

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "…",
    })
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      -- TODO: figure out how to cancel snippet so tab works better
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
