filetype plugin indent on
autocmd TermOpen * startinsert

set expandtab
set tabstop=2
set shiftwidth=2
set list
set listchars=tab:⇢\ ,trail:·

set number
set hidden

set hlsearch

let g:deoplete#enable_at_startup = 1

let g:prettier#config#config_precedence = 'prefer-file'

set cursorline

set autoread
au CursorHold * checktime

colorscheme onehalfdark
let g:airline_theme='onehalfdark'
let g:airline#extensions#tabline#enabled=1

hi CurrentWord ctermbg=53
hi CurrentWordTwins ctermbg=237

set backspace=indent,eol,start

"nnoremap <leader>d :ALEGoToDefinition <cr>
"nnoremap <leader>yr :ALEFindReferences <cr>
"nnoremap <leader>yt :ALEHover <cr>
"nnoremap <leader>yf :ALESymbolSearch <cr>


nnoremap <leader>d :lua vim.lsp.buf.definition()<cr>
nnoremap <leader>r :TermExec cmd="yarn deploy"<cr>
nnoremap <leader>c :TermExec cmd="yarn package"<cr>
nnoremap <leader>x :TermExec cmd="yarn debug:prepare"<cr>

nnoremap <leader>fm :lua conform.format({})<cr>

nnoremap <leader>tt :ToggleTerm<cr>
nnoremap <leader>td :TodoTelescope<cr>
nnoremap <leader>q :close<cr>

nnoremap <leader>? :TermExec cmd="grep ^nnoremap /Users/boro/.config/nvim/vimrc.vim"<cr>
nnoremap <leader>ha :lua harpoon:list():append()<cr>
nnoremap <leader>hd :lua harpoon:list():remove()<cr>
nnoremap <leader>hl :lua harpoon.ui:toggle_quick_menu(harpoon:list())<cr>

nnoremap <leader>bb :lua dap.toggle_breakpoint()<cr>
nnoremap <leader>bo :lua dap.repl.open()<cr>
nnoremap <leader>bh :lua dap_widgets.hover()<cr>
nnoremap <leader>bp :lua dap_widgets.preview()<cr>
nnoremap <leader>bc :lua dap.continue()<cr>

nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fl <cmd>Telescope git_status<cr>
nnoremap <leader>fx <cmd>Telescope git_bcommits<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fS :Ag -i <c-r><c-w><cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>be <cmd>Telescope buffers<cr>
nnoremap <leader>bd :let curr = bufnr('%')<Bar>%bd<Bar>exec 'b' curr<cr>

nnoremap <leader>fh :lua toggle_telescope(harpoon:list())<cr>
nnoremap <leader>f? <cmd>Telescope help_tags<cr>

nnoremap <leader>rw :%s/\<<c-r><c-w>\>//g<left><left>

nnoremap <leader>vv "dP
nnoremap <leader>vc "eP
nnoremap <leader>vb "bP

nnoremap <leader>yv "dyy
nnoremap <leader>yc "eyy
nnoremap <leader>yb "byy

nnoremap <leader>gs :Neogit<cr>
nnoremap <leader>gp :Gitsigns preview_hunk_inline<cr>

nnoremap <leader>nf :NvimTreeFindFile<cr>
nnoremap <leader>nt :NvimTreeToggle<cr>

"nnoremap <leader>ot :Trouble diagnostics toggle<cr>

let g:bookmark_sign='>>'

syntax on
set re=0

au BufRead,BufNewFile *.bs set filetype=brs

