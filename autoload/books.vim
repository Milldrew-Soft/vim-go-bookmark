let s:booksDirectory = expand('~/.go-bookmark')
let s:booksJsonFile = s:booksDirectory . '/books.json'

function CreateBooksDirectory()
  if !isdirectory(s:booksDirectory)
    call mkdir(s:booksDirectory)
  endif
endfunction


" Create books.json if it doesn't exist
function! books#init()
  call CreateBooksDirectory()
  if !filereadable(s:booksJsonFile)
    call writefile(['{}'], s:booksJsonFile)
  endif
endfunction

function! books#doesBookExist(book)
  let books = GetBooks()
  return has_key(books, a:book)
endfunction

function! books#listBooks()
  let books = GetBooks()
  for book in keys(books)
    echo book . ' - ' . books[book]
  endfor
endfunction
function books#addBookWithNotePrompt(book)
  let bookNote = input('Enter note for ' . a:book . ': ')
  call books#addBook(a:book, bookNote)
endfunction

function! books#addBook(book, bookNote)
  echo "Add book"
  let books = GetBooks()
  if has_key(books, a:book)
    echo "Book " . a:book . " already exists"
    return
  endif
  let books[a:book] = a:bookNote
  call WriteBooks(books) 
  call AddBookJsonFile(a:book)
endfunction

function! books#deleteBook(book) 
  let books = GetBooks()
  if !has_key(books, a:book)
    echo "Book " . a:book . " does not exist"
    return
  endif
  ''
  call delete(s:booksDirectory . '/' . a:book . '.book.json')
  call delete(s:booksDirectory . '/' . a:book . '.book.json.broken')
  " remove key value from books.json
  call remove(books, a:book)
  call WriteBooks(books)
  echo "Deleted book: " . a:book
endfunction

function! GetBooks()
  let booksJson = readfile(s:booksJsonFile)
  try
  let books = json_decode(join(booksJson,''))
  catch
    let books = {}
    call rename(s:booksJsonFile, s:booksJsonFile . '.broken')
    echo "Error reading books.json, renamed to books.json.broken"
    call WriteBooks(books)
    echo "Created new blank books.json"
  endtry
  return books
endfunction

function! WriteBooks(books)
  let booksJson = json_encode(a:books)
  call writefile([booksJson], s:booksJsonFile)
endfunction


function! AddBookJsonFile(book)
  let newBookJsonFile = books#getBookFilePath(a:book)
  if !filereadable(expand(newBookJsonFile))
    call writefile(['{}'], newBookJsonFile)
    echo "Created " . newBookJsonFile
  else
    echo newBookJsonFile . " already exists"
  endif
endfunction

function! books#getBookFilePath(book)
  return s:booksDirectory . '/' . a:book . '.book.json'
endfunction

