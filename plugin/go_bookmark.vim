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
"  ────────────────────────────────────────────────────────────────────────────
let s:booksJsonFile = expand('~/.go-books.json')
command! GoBookMarks call go_bookmark#all(1)

"vimscript algorithm -----
" create a directory named ~/.go-bookmarks/books.json
" create the default book named ~/.go-bookmarks/default.book.json
" When GoBookAdd <bookname> is called, create a new book named <bookname>.book.json
" When GoBookDelete <bookname> is called, delete the book named <bookname>.book.json
" When GoBookList is called, list all the books
" When GoBookSelect <bookname> is called, select the book named <bookname>.book.json for bookmarking
" When GoBookMarksList is called, list all the bookmarks in the selected book
" When gb<char> is called, bookmark the current location with the character <char>
" when gB<char> is called, go to the bookmarked location with the character <char>
