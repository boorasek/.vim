
if exists("did_load_filetypes")
        finish
endif

augroup filetypedetect
    au BufNewFile,BufRead *.ttcn  setf ttcn
    au BufNewFile,BufRead *.ttcn3  setf ttcn
    au BufNewFile,BufRead *.antlr setf antlr
 augroup END 
