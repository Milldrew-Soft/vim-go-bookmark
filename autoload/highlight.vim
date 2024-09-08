


highlight BookMarkedLine cterm=NONE ctermbg=yellow ctermfg=black guibg=yellow guifg=black

function! highlight#AddSignToLine(mark) abort
  call highlight#RemoveSignAndHighlight(a:mark)
  let l:line = line('.')
  let l:signDef = a:mark . '-bookmark'
    call sign_define(l:signDef, {'text': a:mark, 'texthl': 'BookMarkedLine' , 'linehl': 'BookMarkedLine'})
    call sign_place(l:line, l:signDef, l:signDef, '', {'lnum': l:line})
endfunction

function! highlight#RemoveSignAndHighlight(mark) abort
  let l:signDef = a:mark . '-bookmark'
  call sign_unplace(l:signDef)
endfunction


call highlight#AddSignToLine('A')
"call GetSignOfLine(line('.'))
" call highlight#RemoveSignAndHighlight('A')
