let s:selectedBook = 'default'
echo 'GoBookmarks setting ' . s:selectedBook . ' as the selected book'
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

" When GoBookMarksList is called, list all the bookmarks in the selected book
call go_bookmark#printFormattedBookmarks(GetSelectedBookFilePath())

" When gb<char> is called, bookmark the current location with the character <char>
function! SetBookMark(char) abort
  echo 'Setting bookmark ' . a:char . ' in ' . GetSelectedBookFilePath()
  call go_bookmark#SetBookMark(a:char, GetSelectedBookFilePath())
endfunction


" vimscript algorithm -----
" when gB<char> is called, go to the bookmarked location with the character <char>
function! GoToBookMark(char)
  echo 'Going to bookmark ' . a:char . ' in ' . GetSelectedBookFilePath()
  call go_bookmark#GoToBookMark(a:char, GetSelectedBookFilePath())
endfunction

function! GetSelectedBookFilePath()
  return books#getBookFilePath(s:selectedBook)
endfunction

" GoBookmarksList lists all the bookmarks in the selected book
" GoBookmarksEdit opens the selected book in a new tab for editing
"
"
function! GoBookmarksList()
  echo 'Listing bookmarks in book: ' . s:selectedBook
  call go_bookmark#printFormattedBookmarks(GetSelectedBookFilePath())
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
"COMMANDS ────────────────────────────────────────────
"COMMANDS ────────────────────────────────────────────
"COMMANDS ────────────────────────────────────────────
"COMMANDS ────────────────────────────────────────────
" When GoBookAdd <bookname> is called, create a new book named <bookname>.book.json
command! -nargs=1 GoBookAdd call books#addBookWithNotePrompt(<f-args>)

" When GoBookDelete <bookname> is called, delete the book named <bookname>.book.json
command! -nargs=1 GoBookDelete call books#deleteBook(<f-args>)


" When GoBookList is called, list all the books
command! GoBookList call books#listBooks()


" When GoBookSelect <bookname> is called, select the book named <bookname>.book.json for bookmarking
command! -nargs=1 GoBookSelect call SetSelectedBook(<f-args>)

" When GoBookmarksList is called, list all the bookmarks in the selected book
command! GoBookmarksList call GoBookmarksList()

