set nohidden
   augroup my_netrw_mappings
     " Target netrw filetype specifically
     autocmd FileType netrw call UnmapNetrwDefaultMappings()
   augroup END

   function! UnmapNetrwDefaultMappings()
     if hasmapto('<Plug>NetrwBookHistHandler_gb')
       nunmap <buffer> gb
     endif
   endfunction

" create  ~/.go-bookmark/books.json if it does not exist
call books#init()

" create the default books 0-9
"
for i in range(0, 9)
  let bookname = 'book' . i
  call books#addBook(i, '')
endfor
call books#addBook('defaultBook', '0')
call books#addBook('selectedBook', '0')

let g:goBookmarkSelectedBook =  books#getDefaultBook()

function! SetSelectedBook(bookname) abort
  let doesBookExist = books#doesBookExist(a:bookname)
  if doesBookExist
    let g:goBookmarkSelectedBook = a:bookname
    call books#editBook('selectedBook', a:bookname)

    echom "Setting selected book to " a:bookname
    call books#printBookNote(a:bookname)
  else
    echom "Book" a:bookname "does not exist"
  endif
endfunction
silent! call SetSelectedBook(g:goBookmarkSelectedBook) 


" When GoBookMarksList is called, list all the bookmarks in the selected book
" call bookmarks#printFormattedBookmarks(GetSelectedBookFilePath())

" When gb<char> is called, bookmark the current location with the character <char>
function! SetBookMark(char) abort
  echom 'Setting bookmark ' . a:char . ' in ' . GetSelectedBookFilePath()
  call bookmarks#SetBookMark(a:char, GetSelectedBookFilePath())
  call highlight#AddSignToLine(a:char)
endfunction


" vimscript algorithm -----
" when gB<char> is called, go to the bookmarked location with the character <char>
function! GoToBookMark(char)
  echom 'Going to bookmark ' . a:char . ' in ' . GetSelectedBookFilePath()
  call bookmarks#GoToBookmark(a:char )
endfunction

function! GetSelectedBookFilePath()
  return books#getBookFilePath(g:goBookmarkSelectedBook)
endfunction

" GoBookmarksList lists all the bookmarks in the selected book
" GoBookmarksEdit opens the selected book in a new tab for editing
"
"
function! GoBookmarksList()
  echom 'Listing bookmarks in book: ' . g:goBookmarkSelectedBook
  call bookmarks#printFormattedBookmarks(GetSelectedBookFilePath())
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
" gbbE<char> edit the bookmark of the selected book

" 0-9 loop
for char in range(0, 9)
  execute 'nnoremap gbbs' . char . ' :call SetSelectedBook("'.char.'")<CR>'
  execute 'nnoremap gb' . char . ' :call GoToBookMark("'.char.'")<CR>'
  execute 'nnoremap gB'. char.' :call SetBookMark("'.char.'")<CR>'
  " edit the bookmark of the selected book
  execute 'nnoremap gbbe'.char.' :call bookmarks#EditBookMarkNote("'.char.'")<CR>'
  " delete the bookmark of the selected book"
  execute 'nnoremap gbbd'.char.' :call bookmarks#DeleteBookMark("'.char.'")<CR>'

endfor

" a-z loop
for char in range(char2nr('a'), char2nr('z'))
  execute 'nnoremap gb'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbe'.nr2char(char).' :call bookmarks#EditBookMarkNote("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbd'.nr2char(char).' :call bookmarks#DeleteBookMark("'.nr2char(char).'")<CR>'
  if char == char2nr('b')
    continue
  endif
  execute 'nnoremap gB'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
endfor
" A-Z loop
for char in range(char2nr('A'), char2nr('Z'))
  execute 'nnoremap gB'.nr2char(char).' :call SetBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gb'.nr2char(char).' :call GoToBookMark("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbe'.nr2char(char).' :call bookmarks#EditBookMarkNote("'.nr2char(char).'")<CR>'
  execute 'nnoremap gbbd'.nr2char(char).' :call bookmarks#DeleteBookMark("'.nr2char(char).'")<CR>'
endfor

nnoremap gb :echo 'going to bookmark timed out'<CR>
nnoremap gB :echo 'setting bookmark timedout'<CR>
nnoremap gbb :echo 'a custom go bookmark keystroke timeout or fall through'<CR>
nnoremap gbbs :echo 'select book timeout fall through'<CR>
nnoremap gbbL :call books#listBooks()<CR>
nnoremap gbbE :call books#editNote(g:goBookmarkSelectedBook)<CR>
nnoremap gbbd :echo 'delete bookmark fall through timeout'<CR>
nnoremap gbbS :call books#chooseDefaultBook()<CR>
nnoremap gbbl :call GoBookmarksList()<CR>

"─────────────────── HIGH LIGHT BOOKMARKED LINES WHEN FILE IS OPENED ───────────────────
augroup highlight_bookmarks
    autocmd! BufEnter * call highlight#AddHighlightToExistingBookmarks(GetSelectedBookFilePath())
augroup END



