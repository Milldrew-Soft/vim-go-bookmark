


highlight BookMarkedLine cterm=NONE ctermbg=white ctermfg=black guibg=white guifg=black

function! highlight#AddSignToLineOnBufferOpen(mark, line) abort
  " call highlight#RemoveSignAndHighlight(a:mark)
  
  let l:signDef = a:mark . '-bookmark'
  let l:signDefConfig = {'text': a:mark, 'texthl': 'BookMarkedLine' , 'linehl': 'BookMarkedLine'}
  "call sign_define(l:signDef, {'text': a:mark, 'texthl': 'BookMarkedLine' , 'linehl': 'BookMarkedLine'})
  call sign_define(l:signDef, l:signDefConfig)
  echo json_encode(l:signDefConfig)
  let l:bufName = bufname()
  echo l:bufName . 'bufName'
 "call sign_place(0, l:signDef, l:signDef,''   , {'lnum': a:line})
 "echo 'call sign_place(0,'.  l:signDef . ',' . l:signDef .', ' ."''" . "  , {'lnum':" .  a:line .'})'
 call sign_place(0, l:signDef, l:signDef, l:bufName  , {'lnum': a:line})
 echo 'call sign_place(0,'.  l:signDef . ',' . l:signDef .', '. l:bufName . "  , {'lnum':" .  a:line .'})'
endfunction

function! highlight#AddSignToLine(mark) abort
  let l:line = line('.')
  call highlight#AddSignToLineOnBufferOpen(a:mark, l:line)
endfunction

function! highlight#RemoveSignAndHighlight(mark) abort
  let l:signDef = a:mark . '-bookmark'
  call sign_unplace(l:signDef)
endfunction
function! highlight#AddHighlightToExistingBookmarks(currentBookmarksFilePath) abort
  let l:currentFile = expand('%:p')
  if &filetype ==# 'netrw'
    let l:currentFile = getcwd() . '/'
  endif
  let l:currentBookmarks = readfile(a:currentBookmarksFilePath)
  let l:currentBookmarksJson = json_decode(join(l:currentBookmarks, ''))

  for bookmark in keys(l:currentBookmarksJson)
    let l:value = l:currentBookmarksJson[bookmark]
    let filePathLineColumn = l:value['filePathLineColumn']
    let [filePath, line, column] = split(filePathLineColumn, ':')
    if filePath == l:currentFile
      call highlight#AddSignToLineOnBufferOpen(bookmark, line)
    endif
  endfor

endfunction
