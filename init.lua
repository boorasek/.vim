
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('scrooloose/nerdtree', { on = 'NERDTreeToggle' })
Plug('sonph/onehalf', { rtp = 'vim/' })
Plug('jlanzarotta/bufexplorer')
Plug('chooh/brightscript.vim')
Plug('bling/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('lfv89/vim-interestingwords')
Plug('dominikduda/vim_current_word')
Plug('tpope/vim-sensible')
Plug('tpope/vim-fugitive')
Plug("sindrets/diffview.nvim")
Plug("NeogitOrg/neogit")
Plug('epmatsw/ag.vim')
Plug('MattesGroeger/vim-bookmarks')
Plug('raimondi/delimitmate')
Plug('will133/vim-dirdiff')
Plug('Chun-Yang/vim-action-ag')
Plug('nvim-lua/plenary.nvim')
Plug('BurntSushi/ripgrep')
Plug('neovim/nvim-lspconfig')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.3' })
Plug('akinsho/toggleterm.nvim', { tag = '*'})
Plug('RRethy/vim-illuminate')
Plug('folke/trouble.nvim')
Plug('akinsho/bufferline.nvim', { tag = '*' })
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/nvim-cmp')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

vim.call('plug#end')

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

vim.opt.termguicolors = true

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

require("trouble").setup({ icons = false })
require("toggleterm").setup()
require("diffview").setup({})
require('neogit').setup({})

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

local cmp = require'cmp'
cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-p>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif ls.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif ls.jumpable(-1) then
          ls.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'luasnip' },
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
vim.api.nvim_create_user_command("GrepCword", grep_cword, {})

local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)
