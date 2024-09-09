nnoremap gbbs :call books#chooseDefaultBook()<CR>
" create  ~/.go-bookmark/books.json if it does not exist
call books#init()

" create the default books 0-9
"
for i in range(0, 9)
  let bookname = 'book' . i
  call books#addBook(i, '')
endfor
call books#addBook('defaultBook', '0')
let g:goBookmarkSelectedBook =  books#getDefaultBook()
echo 'GoBookmarks setting ' . g:goBookmarkSelectedBook . ' as the selected book'

function! SetSelectedBook(bookname) abort
  let doesBookExist = books#doesBookExist(a:bookname)
  if doesBookExist
    echo "Setting selected book to " a:bookname
    let g:goBookmarkSelectedBook = a:bookname
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
  call highlight#AddSignToLine(a:char)
endfunction


" vimscript algorithm -----
" when gB<char> is called, go to the bookmarked location with the character <char>
function! GoToBookMark(char)
  echo 'Going to bookmark ' . a:char . ' in ' . GetSelectedBookFilePath()
  call go_bookmark#GoToBookMark(a:char, GetSelectedBookFilePath())
endfunction

function! GetSelectedBookFilePath()
  return books#getBookFilePath(g:goBookmarkSelectedBook)
endfunction

" GoBookmarksList lists all the bookmarks in the selected book
" GoBookmarksEdit opens the selected book in a new tab for editing
"
"
function! GoBookmarksList()
  echo 'Listing bookmarks in book: ' . g:goBookmarkSelectedBook
  call go_bookmark#printFormattedBookmarks(GetSelectedBookFilePath())
endfunction


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


" MAPPINGS ─────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" ────────────────────────────────────────────────────────────────────────────
" create all bookmark keystrokes ─────────────────────────────────────────────

" gbbl list all bookmarks in the selected book
nnoremap gbbl :call GoBookmarksList()<CR>
" gbbE<char> edit the bookmark of the selected book

" 0-9 loop
for char in range(0, 9)
  let acutalChar = char
  execute 'nnoremap gbbS'.acutalChar.' :call SetSelectedBook("'.acutalChar.'")<CR>'
  execute 'nnoremap gb'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gB'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
  " edit the bookmark of the selected book
  execute 'nnoremap gbbe'.char.' :call go_bookmark#EditBookMarkNote("'.char.'","' . GetSelectedBookFilePath() . '")<CR>'
  " delete the bookmark of the selected book"
  " execute 'nnoremap gbbd'.char.' :call go_bookmark#DeleteBookMark("'.char.'","' . GetSelectedBookFilePath() . '")<CR>'
  execute 'nnoremap gbbd'.nr2char(char).' :call go_bookmark#DeleteBookMark("'.nr2char(char).'","' . GetSelectedBookFilePath() . '")<CR>'

endfor

" a-z loop
for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gb'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbe'.nr2char(char).' :call go_bookmark#EditBookMarkNote("'.nr2char(char).'","' . GetSelectedBookFilePath() . '")<CR>'
  execute 'nnoremap gbbd'.nr2char(char).' :call go_bookmark#DeleteBookMark("'.nr2char(char).'","' . GetSelectedBookFilePath() . '")<CR>'
  if char == char2nr('b')
    continue
  endif
  execute 'nnoremap gB'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor
" A-Z loop
for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gB'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gb'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbe'.nr2char(char).' :call go_bookmark#EditBookMarkNote("'.nr2char(char).'","' . GetSelectedBookFilePath() . '")<CR>'
  execute 'nnoremap gbbd'.nr2char(char).' :call go_bookmark#DeleteBookMark("'.nr2char(char).'","' . GetSelectedBookFilePath() . '")<CR>'
endfor

nnoremap gbb :echo 'go bookmark keystroke timeout or fall through'<CR>
nnoremap gbbS :echo 'select book timeout fall through'<CR>
nnoremap gbbL :call books#listBooks()<CR>
nnoremap gbbE :call books#editNote(g:goBookmarkSelectedBook)<CR>
nnoremap gbbd :echo 'delete bookmark fall through timeout'<CR>

"─────────────────── HIGH LIGHT BOOKMARKED LINES WHEN FILE IS OPENED ───────────────────
  augroup
    autocmd!
    autocmd BufEnter * call highlight#AddHighlightToExistingBookmarks(GetSelectedBookFilePath())
  augroup END




