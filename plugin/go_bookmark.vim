let s:selectedBook = 'default'
" create  ~/.go-bookmark/books.json if it does not exist
call books#init()


" create the default book named ~/.go-bookmarks/default.book.json
call books#addBook(s:selectedBook, 'the default book')

function! SetSelectedBook(bookname)
  let doesBookExist = books#doesBookExist(a:bookname)
  if doesBookExist
    let s:selectedBook = a:bookname
  else
    echo "Book" a:bookname "does not exist"
  endif
endfunction

" When GoBookAdd <bookname> is called, create a new book named <bookname>.book.json
command! -nargs=1 GoBookAdd call books#addBook(<f-args>)

" When GoBookDelete <bookname> is called, delete the book named <bookname>.book.json
command! -nargs=1 GoBookDelete call books#deleteBook(<f-args>)


" When GoBookList is called, list all the books
command! GoBookList call books#listBooks()


" When GoBookSelect <bookname> is called, select the book named <bookname>.book.json for bookmarking
command! -nargs=1 GoBookSelect call SetSelectedBook(<f-args>)

" When GoBookMarksList is called, list all the bookmarks in the selected book
call go_bookmark#printFormattedBookmarks(GetSelectedBookFilePath())

" When gb<char> is called, bookmark the current location with the character <char>
function! SetBookMark(char) abort
  call go_bookmark#SetBookMark(char, GetSelectedBookFilePath())
endfunction


" vimscript algorithm -----
" when gB<char> is called, go to the bookmarked location with the character <char>
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

function! GetSelectedBookFilePath()
  return books#getBookFilePath(s:selectedBook)
endfunction

" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" create all bookmark keystrokes ─────────────────────────────────────────────
for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gb'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor

for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gb'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor
for char in range(0, 9)
  execute 'nnoremap gb'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor
for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gB'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
endfor

for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gB'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
endfor
for char in range(0, 9)
  execute 'nnoremap gB'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
endfor
