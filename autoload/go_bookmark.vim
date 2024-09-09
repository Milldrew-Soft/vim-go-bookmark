
function! go_bookmark#SetBookMark(char, selectedBookmarksFilePath) abort
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:selectedBookmarksFilePath)
  let l:filePathLineColumn = expand('%:p') . ':' . line('.') . ':' . col('.')
  let l:bookmarkNotes = input('Enter notes for bookmark ' . a:char . ': ')
  " clear
  redraw |echo 'Notes for bookmark ' . a:char . ': ' . l:bookmarkNotes
  let l:bookMarkInfo = { 'filePathLineColumn': l:filePathLineColumn, 'notes': l:bookmarkNotes }
   let l:bookmarks[a:char] = l:bookMarkInfo
  call HandleWriteBookmarksJsonFile(l:bookmarks, a:selectedBookmarksFilePath)
  call go_bookmark#printFormattedBookmarks(a:selectedBookmarksFilePath)
endfunction

function! SetBookMark(char, bookmarksFilePath) abort
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:bookmarksFilePath)
  let l:filePathLineColumn = expand('%:p') . ':' . line('.') . ':' . col('.')
  let l:bookmarkNotes = input('Enter notes for bookmark ' . a:char . ': ')
  " clear
  redraw |echo 'Notes for bookmark ' . a:char . ': ' . l:bookmarkNotes
  let l:bookMarkInfo = { 'filePathLineColumn': l:filePathLineColumn, 'notes': l:bookmarkNotes }
   let l:bookmarks[a:char] = l:bookMarkInfo
  echo 'Bookmarks: ' . string(l:bookmarks)
  call HandleWriteBookmarksJsonFile(l:bookmarks)
  call go_bookmark#printFormattedBookmarks()
endfunction
function! FormatString(str)
  let l:len = strlen(a:str)
  " If the string is longer than 20 characters, truncate and add "..."
  if l:len > 30
    let start = l:len - 28
    return '...' . strpart(a:str, start) 
  else
    " Calculate padding needed to center the text
    let l:padding = (30 - l:len) / 2
    let l:left_padding = repeat(' ', l:padding)
    let l:right_padding = repeat(' ', l:padding)
    " return l:left_padding . a:str . l:right_padding
    return a:str . l:right_padding . l:left_padding
  endif
endfunction

function! go_bookmark#printFormattedBookmarks(bookmarksFilePath)
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:bookmarksFilePath)
  let l:fileHeader = FormatString('File')
  echo 'Mark • '.l:fileHeader.' • Notes'
  echo '─────────────────────────────────────────────'
  for key in sort(keys(l:bookmarks))
    let value = l:bookmarks[key]
    let markFileName = fnamemodify(value['filePathLineColumn'], ':t')
    let markFileName = FormatString(markFileName)
    echo  key . '    • ' . markFileName . ' • ' . value['notes']
  endfor
endfunction

function! HandleGetGoBookmarksJsonFile(bookmarksFilePath)
  let l:hasBookmarksFile = filereadable(a:bookmarksFilePath)
  if l:hasBookmarksFile
    let l:bookmarksJson = readfile(a:bookmarksFilePath)
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
    echo 'No bookmarks file found at ' . a:bookmarksFilePath
    call writefile(['{}'], a:bookmarksFilePath)
    let l:bookmarks = {}
  endif
  return l:bookmarks
endfunction
function! HandleWriteBookmarksJsonFile(bookmarks, bookmarksFilePath)
  let l:bookmarksJson = json_encode(a:bookmarks)
  call writefile([l:bookmarksJson], a:bookmarksFilePath)
endfunction

function! go_bookmark#GoToBookMark(char, bookmarksFilePath) abort
  :write
  echo 'Going to bookmark ' . a:char
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:bookmarksFilePath)
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

function! go_bookmark#EditBookMarkNote(char, bookmarksFilePath) abort
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:bookmarksFilePath)
  let l:bookmark = l:bookmarks[a:char]
  if !empty(l:bookmark)
    let l:bookmarkNotes = input('Enter notes for bookmark ' . a:char . ': ', l:bookmark['notes'])
    let l:bookmark['notes'] = l:bookmarkNotes
    let l:bookmarks[a:char] = l:bookmark
    call HandleWriteBookmarksJsonFile(l:bookmarks, a:bookmarksFilePath)
    call go_bookmark#printFormattedBookmarks(a:bookmarksFilePath)
  else
    echo 'No bookmark found for ' . a:char
  endif
endfunction

function! go_bookmark#DeleteBookMark(char, bookmarksFilePath) abort
  let l:bookmarks = HandleGetGoBookmarksJsonFile(a:bookmarksFilePath)
  let l:bookmark = l:bookmarks[a:char]
  if !empty(l:bookmark)
    let l:bookmarkNotes = input('Are you sure you want to delete bookmark ' . a:char . '? (y/n): ')
    if l:bookmarkNotes == 'y'
      call remove(l:bookmarks, a:char)
      call HandleWriteBookmarksJsonFile(l:bookmarks, a:bookmarksFilePath)
      call go_bookmark#printFormattedBookmarks(a:bookmarksFilePath)
    else
      echo 'Bookmark ' . a:char . ' was not deleted'
    endif
  else
    echo 'No bookmark found for ' . a:char
  endif
endfunction


