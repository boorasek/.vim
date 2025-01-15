local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('github/copilot.vim')
Plug('lewis6991/gitsigns.nvim')
Plug('lukas-reineke/cmp-rg')
Plug('luckasRanarison/tailwind-tools.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
Plug('sonph/onehalf', { rtp = 'vim/' })
Plug('chooh/brightscript.vim')
Plug('bling/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('lfv89/vim-interestingwords')
Plug('dominikduda/vim_current_word')
Plug('stevearc/conform.nvim')
Plug('tpope/vim-sensible')
Plug('tpope/vim-fugitive')
Plug('mfussenegger/nvim-dap')
Plug("sindrets/diffview.nvim")
Plug("NeogitOrg/neogit")
Plug('epmatsw/ag.vim')
Plug('MattesGroeger/vim-bookmarks')
Plug('raimondi/delimitmate')
Plug('will133/vim-dirdiff')
Plug('Chun-Yang/vim-action-ag')
Plug('kevinhwang91/nvim-bqf', { ft = 'qf' })
Plug('nvim-lua/plenary.nvim')
Plug('BurntSushi/ripgrep')
Plug('neovim/nvim-lspconfig')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.3' })
Plug('akinsho/toggleterm.nvim', { tag = '*'})
Plug('RRethy/vim-illuminate')
Plug('folke/trouble.nvim')
Plug('akinsho/bufferline.nvim', { tag = '*' })
Plug('ThePrimeagen/harpoon', { branch = 'harpoon2' })
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/nvim-cmp')
Plug('L3MON4D3/LuaSnip')
Plug('folke/todo-comments.nvim')
Plug('saadparwaiz1/cmp_luasnip')
Plug('ntpeters/vim-better-whitespace')
Plug('SergioRibera/cmp-dotenv')
Plug('kylechui/nvim-surround')

vim.call('plug#end')

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "javascript", "typescript", "markdown", "markdown_inline"
},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
})

require("nvim-surround").setup({})

conform = require("conform")
conform.setup({
  formatters = {
    eslint = {
      command = "eslint",
      args = { "$FILENAME", "--fix" },
    },
  },
  formatters_by_ft = {
    ["bs"] = { "bsfmt", lsp_format = "fallback" },
    ["brs"] = { "bsfmt", lsp_format = "fallback" },
    ["xml"] = { "prettier", lsp_format = "fallback" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    json = { "eslint_d" },
  },
  format_on_save = {
    timeout_ms = 500,
    -- lsp_format = "fallback",
  },
--  format_after_save = {
--  },
})

require("bufferline").setup {
  options = {
    indicator = {
        style = 'underline'
    },
    diagnostics = "nvim_lsp",
    left_trunc_marker = '',
    right_trunc_marker = '',
    buffer_close_icon = ''
  }
}

require'telescope'.setup({
  defaults = {
    file_ignore_patterns = { "^./.git/", "^./node_modules/", "^./dist/", "^./src/images/", "%.png" },
  }
})

require('gitsigns').setup()
require("toggleterm").setup({
  size = 10,
  close_on_exit = true,

})
require("trouble").setup({
  modes = {
    diagnostics = {
      auto_close = true,
      auto_open = true,
      open_no_results = true,
    },
  }
})
require("todo-comments").setup()
require("diffview").setup({})
require('neogit').setup({})
require('bqf').setup({func_map = {}})

harpoon = require('harpoon')
harpoon.setup({})

local conf = require("telescope.config").values
function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

ls = require("luasnip")
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
ls.config.setup({store_selection_keys="<Tab>"})

require("luasnip.loaders.from_vscode").load_standalone({ path = "~/.config/nvim/snippets.code-snippets" })

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

local has_words_before = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s')
end

local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-p>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
     --   ["<Tab>"] = cmp.mapping(function(fallback)
     --     if cmp.visible() then
     --       cmp.select_next_item()
     --     elseif ls.expand_or_jumpable() then
     --       ls.expand_or_jump()
     --     elseif has_words_before() then
     --       cmp.complete()
     --     else
     --       fallback()
     --     end
     --   end, { "i", "s" }),
     --   ["<S-Tab>"] = cmp.mapping(function(fallback)
     --     if cmp.visible() then
     --       cmp.select_prev_item()
     --     elseif ls.jumpable(-1) then
     --       ls.jump(-1)
     --     else
     --       fallback()
     --     end
     --   end, { "i", "s" }),
     }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'luasnip' },
      { name = "rg",
        keyword_length = 3
      },
 --   { name = "dotenv" }
    }),
    snippet = {
      expand = function(args)
        local luasnip = prequire("luasnip")
          if not luasnip then
            return
          end
        luasnip.lsp_expand(args.body)
      end,
    },
})

lspconfig.bright_script.setup({
  defaults = {
    filetypes = { "brs", "bs"}
  }
})

lspconfig.jsonls.setup({
})

lspconfig.ts_ls.setup({
})

lspconfig.eslint.setup({})

currentDir = vim.fn.getcwd()

dap = require('dap')
dap.adapters.brightscript = {
  type = 'executable',
  command = 'npx',
  args = { 'roku-debug', '--dap' },
}

dap.configurations.brs = {
  {
    type = 'brightscript',
    request = 'launch',
    name = "Debug app",
    rootDir = currentDir .. "/out/package",
    files = {
       "manifest",
       "commit-sha",
       "synergy-sha",
       "source/**/*.*",
       "components/**/*.*",
       "resources/**/*.*"
    },
    host = "${env:ROKU_IP}",
    remotePort = 8060,
    password = "${env:ROKU_PASSWORD}",
    outDir = currentDir .. "/out/",
    retainStagingFolder = false,
    rendezvousTracking = false,
    injectRdbOnDeviceComponent = false,
    -- stopDebuggerOnAppExit = true,
    -- enableDebuggerAutoRecovery = true,
    enableSourceMaps = true,
    enableDebugProtocol = true,
    enableVariablesPanel = true,
    fileLogging = false,
    logLevel = "off"
  },
}

dap_widgets = require('dap.ui.widgets')

require('illuminate').configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  delay = 100,
  under_cursor = true,
  case_insensitive_regex = true,
})

local telescopebuiltin = require("telescope.builtin")

local function grep_cword()
  return telescopebuiltin.grep_string({search = vim.fn.expand("<cword>")})
end

telescopebuiltin.buffers({
  sort_mru = true, -- Sort by Most Recently Used first
  --sort_lastused = true,
  previewer = false,
  --ignore_current_buffer = true, -- Exclude the currently active buffer
   show_all_buffers = false, -- Show all buffers, including hidden ones
})

require("tailwind-tools").setup({
  conceal = {
    enabled = true,
  }
})

local vim = vim
local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"


vim.api.nvim_create_user_command("GrepCword", grep_cword, {})

local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = { "*" },
  command = [[NvimTreeOpen]],
})
