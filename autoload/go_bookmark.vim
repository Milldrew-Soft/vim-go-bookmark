  let s:bookmarksJsonFile = expand('~/.go-bookmarks.json')
function! SetBookMark(char) abort
  let l:bookmarks = HandleGetGoBookmarksJsonFile()
  let l:filePathLineColumn = expand('%:p') . ':' . line('.') . ':' . col('.')
  let l:bookmarkNotes = input('Enter notes for bookmark ' . a:char . ': ')
  " clear
  redraw |echo 'Notes for bookmark ' . a:char . ': ' . l:bookmarkNotes
  let l:bookMarkInfo = { 'filePathLineColumn': l:filePathLineColumn, 'notes': l:bookmarkNotes }
   let l:bookmarks[a:char] = l:bookMarkInfo
  echo 'Bookmarks: ' . string(l:bookmarks)
  call HandleWriteBookmarksJsonFile(l:bookmarks)
  call PrintFormattedBookmarks()
endfunction

function! PrintFormattedBookmarks()
  let l:bookmarks = HandleGetGoBookmarksJsonFile()
  for [key, value] in items(l:bookmarks)
    echo 'Bookmark ' . key . ': ' . value['filePathLineColumn'] . ' - ' . value['notes']
  endfor
endfunction

command! -nargs=0 GoBookmarks :call PrintFormattedBookmarks()
command! GoBookmarksEdit :exec ':edit ' . s:bookmarksJsonFile
function! HandleGetGoBookmarksJsonFile()
  let l:hasBookmarksFile = filereadable(s:bookmarksJsonFile)
  
  if l:hasBookmarksFile
    let l:bookmarksJson = readfile(s:bookmarksJsonFile)
    :try
    let l:bookmarks = json_decode(join(l:bookmarksJson, ''))
  catch 
    let brokenBookmarksFilePath = s:bookmarksJsonFile . '.broken'
    call rename(s:bookmarksJsonFile, brokenBookmarksFilePath)
    call writefile(['{}'], s:bookmarksJsonFile)
    let l:bookmarks = {}
    echo 'Broken bookmarks file found at ' . s:bookmarksJsonFile . '. Renamed to ' . s:bookmarksJsonFile . '.broken'
    echo 'A new bookmarks file has been created at ' . s:bookmarksJsonFile
  finally
    endtry
  else
    echo 'No bookmarks file found at ' . s:bookmarksJsonFile . '. Creating new file.'
    call writefile(['{}'], s:bookmarksJsonFile)
    let l:bookmarks = {}
  endif


  return l:bookmarks
endfunction
function! HandleWriteBookmarksJsonFile(bookmarks)
  let l:bookmarksJson = json_encode(a:bookmarks)
  call writefile([l:bookmarksJson], s:bookmarksJsonFile)
endfunction

for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gb'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor

for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gb'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor
function! GoToBookMark(char)
  echo 'Going to bookmark ' . a:char
  let l:bookmarks = HandleGetGoBookmarksJsonFile()
  let l:bookmark = l:bookmarks[a:char]
  if !empty(l:bookmark)
    let l:filePathLineColumn = l:bookmark['filePathLineColumn']
    let [l:filePath, l:line, l:column] = split(l:filePathLineColumn, ':' )
    echo 'Opening ' . l:filePath . ' at line ' . l:line . ' and column ' . l:column
    execute 'edit ' . l:filePath
    execute l:line
    execute 'normal! ' . l:column . '|'
  else
    echo 'No bookmark found for ' . a:char
  endif
endfunction
for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gB'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
endfor

for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gB'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
endfor


