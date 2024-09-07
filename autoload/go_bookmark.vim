" Primary functions {{{

" function! gitgutter#all(force) abort
"   let visible = tabpagebuflist()

"   for bufnr in range(1, bufnr('$') + 1)
"     if buflisted(bufnr)
"       let file = expand('#'.bufnr.':p')
"       if !empty(file)
"         if index(visible, bufnr) != -1
"           call gitgutter#process_buffer(bufnr, a:force)
"         elseif a:force
"           call s:reset_tick(bufnr)
"         endif
"       endif
"     endif
"   endfor
" endfunction
