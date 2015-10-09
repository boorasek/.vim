
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" support for 256 colors in terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set backspace=indent,eol,start " allow backspacing over everything in insert mode


" set directories to store *~ and *swp files
set backupdir=~/.backup,/tmp
set directory=~/.backup,/tmp

set history=50   " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd      " display incomplete commands
set incsearch    " do incremental searching
set tabstop=4    " tells how many spaces are equal to tab
set shiftwidth=4 " tells how many spaces are used when changing indent with <<, >>
set expandtab    " when expandtab is set, hitting Tab in insert mode will produce the appropriate number of spaces.
set number       " line numbers

set mouse=a      " enable mouse 

" folding options
set foldmethod=syntax

" show trailing/beginning white chars
set list
set listchars=tab:\|-,trail:.,extends:>,precedes:.

" when terminal has colors
if &t_Co > 2
    syntax on    " syntax highlighting
    set hlsearch " hihglighting last used search pattern
endif

" =============== plugin support ==============

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" plugin list 
NeoBundle 'tomasr/molokai'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'markabe/bufexplorer'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'rhysd/vim-clang-format'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'nelson/cscope_maps'
NeoBundle 'bling/vim-airline'
NeoBundle 'nosami/Omnisharp'

NeoBundle 'Valloric/YouCompleteMe', { 'build' : { 'linux' : './install.sh --clang-completer --system-libclang --omnisharp-completer', } }

call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" =========== end of plugin support ============

filetype plugin indent on
syntax enable

colorscheme molokai " best color scheme

" NERD Tree
map <F5> :NERDTreeToggle<cr>
let g:NERDTreeWinSize = 40

" Tagbar
nmap <F6> :TagbarToggle<cr>

" clang-format
" style_options: http://clang.llvm.org/docs/ClangFormatStyleOptions.html
let g:clang_format#command = "clang-format-3.6"
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
  \ "AccessModifierOffset" : -4,
  \ "AlwaysBreakTemplateDeclarations" : "true",
  \ "Standard" : "C++11"}

" Fugitive
set diffopt=filler,vertical
nmap <silent> <leader>gc :Gcommit<CR>
nmap <silent> <leader>gd :Gdiff<CR>
nmap <silent> <leader>gp :Git push<CR>
nmap <silent> <leader>gs :Gstatus<CR>

"alt map - moving between windows
map <C-left> <C-W>h<C-W>_
map <C-right> <C-W>l<C-W>_
map <C-up> <C-W>k<C-W>_
map <C-down> <C-W>j<C-W>_

" line diff
noremap \ldt :Linediff<CR>
noremap \ldo :LinediffReset<CR>

"highlight current line
set cursorline
"
"highlight long lines - more than 120 chars
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%121v.\+/
"
"Removes trailing spaces
function TrimWhiteSpace()
    %s/\s*$//
    ''
:endfunction

map <F2> :call TrimWhiteSpace()<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
"
"load ctags 
function LoadTags()
    set tags+=~/.tags/tags
endfunction

map <F9> :call LoadTags() <CR>

" youcompleteme
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"========================VERIFIED END===================================================================================
"if has("vms")
"  set nobackup " do not keep a backup file, use versions instead
"else
"  set backup " keep a backup file
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")


  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" ============================================================================

" Don't use Ex mode, use Q for formatting
map Q gq


"compile - commented because of conflict with BufExplorer
"map \c :cclose<CR>:make "%:r"<CR>:copen 8<CR><C-W>x<C-W>w
"map \b :make<CR>:copen 8 <CR><C-W>x
"map \n :cn<R
"map \p :cp<CR>


"tab support
set wildchar=<TAB> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <TAB> :b <C-Z>


" Only do this part when compiled with support for autocommands.
if has("autocmd")
"    autocmd FileType c,cpp,h,hpp autocmd FileWritePre * :silent call TrimWhiteSpace()
"    autocmd FileType c,cpp,h,hpp autocmd FileAppendPre * :silent call TrimWhiteSpace()
"    autocmd FileType c,cpp,h,hpp autocmd FilterWritePre * :silent call TrimWhiteSpace()
"    autocmd FileType c,cpp,h,hpp autocmd BufWritePre * :silent call TrimWhiteSpace()
endif " has("autocmd")

nnoremap <leader>a :Ack <cword> 
"
"set term=xterm-256color




map <F10> :call AsyncGenCtags() <CR>

function! AsyncGenCtags()
    let ctags_cmd = "/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f .tags ~/b/ekrzmac/client/Native/*"
    let ctags_func = asynchandler#quickfix("cgetfile", "quickfix")
    call asynccommand#run(ctags_cmd, ctags_func)
    :redraw!
endfunction 

