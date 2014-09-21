" An example for a vimrc file.
"
" Maintainer: Przemek Borowski <boorasek@gmail.com>
" Last change: 2011 Oct 24

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set guioptions=aegirLt
if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup " keep a backup file
endif
set history=50 " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd       		" display incomplete commands
set incsearch       		" do incremental searching
set tabstop=4    		" tells how many spaces are equal to tab
set shiftwidth=4
set expandtab
set number
set foldmethod=syntax


" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

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

"best color scheme
colorscheme molokai

"show trailing/beginning white chars
set list
set listchars=tab:\|-,trail:.,extends:>,precedes:.

"highlight current line
set cursorline

"set wmh=0 "set minimal window height
map <F5> :NERDTreeToggle<cr>
map <F8> :bd<cr>

"ctags
let Tlist_Use_Right_Window = 1
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
map <F7> :tselect<cr>

"alt map - moving between windows
map <C-left> <C-W>h<C-W>_
map <C-right> <C-W>l<C-W>_
map <C-up> <C-W>k<C-W>_
map <C-down> <C-W>j<C-W>_

"load ctags - cplane only
function LoadTags()
"    set tags+=lteDo/Tags/tags
"    set tags+=lteDo/Tags/tags_ut
    set tags+=lteDo/Tags/tags_ttcn3
endfunction

map <F9> :call LoadTags() <CR>

"highlight long lines - more than 120 chars
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%121v.\+/

"Removes trailing spaces
function TrimWhiteSpace()
    %s/\s*$//
    ''
:endfunction

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    autocmd FileType c,cpp,h,hpp autocmd FileWritePre * :silent call TrimWhiteSpace()
    autocmd FileType c,cpp,h,hpp autocmd FileAppendPre * :silent call TrimWhiteSpace()
    autocmd FileType c,cpp,h,hpp autocmd FilterWritePre * :silent call TrimWhiteSpace()
    autocmd FileType c,cpp,h,hpp autocmd BufWritePre * :silent call TrimWhiteSpace()
endif " has("autocmd")

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>
nnoremap <leader>a :Ack <cword> 
let g:NERDTreeWinSize = 40
"let g:molokai_original = 0
"set term=xterm-256color


filetype plugin on
set ofu=syntaxcomplete#Complete

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest
",preview


map <F10> :call AsyncGenCtags() <CR>

function! AsyncGenCtags()
    let ctags_cmd = "/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q C_Application/*"
    let ctags_func = asynchandler#quickfix("cgetfile", "quickfix")
    call asynccommand#run(ctags_cmd, ctags_func)
    :redraw!
endfunction 

