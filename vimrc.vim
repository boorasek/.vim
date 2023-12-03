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
nnoremap <leader>t :ToggleTerm<cr>
nnoremap <leader>q :close<cr>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>vv "dP
nnoremap <leader>vc "eP
nnoremap <leader>vb "bP

nnoremap <leader>yv "dyy
nnoremap <leader>yc "eyy
nnoremap <leader>yb "byy

nnoremap <leader>gs :Neogit<cr>


nnoremap <leader>nf :NERDTreeFind<cr>

let g:bookmark_sign='>>'

nmap <F5> :NERDTreeToggle<cr>
nmap <F4> :Trouble<cr>

syntax on
set re=0

au BufRead,BufNewFile *.bs set filetype=brs

