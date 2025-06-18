*go-bookmark.txt*      A Vim plugin for managing persistent, highlighted bookmarks


                           Vim Go Bookmark


Author:            Andrew Miller
Plugin Homepage:   <https://github.com/Milldrew-Soft/vim-go-bookmark>


===============================================================================
CONTENTS                                                        *go-bookmark*

  Introduction ................. |go-bookmark-introduction|
  Installation ................. |go-bookmark-installation|
  Commands ..................... |go-bookmark-commands|
  Mappings ..................... |go-bookmark-mappings|
  Functions .................... |go-bookmark-functions|
  Configuration ................ |go-bookmark-configuration|
  Highlighting ................. |go-bookmark-highlighting|
  Troubleshooting .............. |go-bookmark-troubleshooting|


===============================================================================
INTRODUCTION                                       *go-bookmark-introduction*

Vim Go Bookmark provides a powerful bookmark management system with:
- Persistent bookmarks across Vim sessions
- Automatic highlighting of bookmarked lines
- Support for multiple bookmark collections ("books")
- Attachable notes for each bookmark
- Quick navigation with mnemonic key bindings
- Intuitive management interface

Features:
- Simple single-character bookmarks (0-9, a-z, A-Z)
- Book-specific bookmark organization
- Visual feedback through line highlighting
- Customizable appearance and behavior


===============================================================================
INSTALLATION                                       *go-bookmark-installation*

Using vim-plug:>
    Plug 'Milldrew-Soft/vim-go-bookmark'
<

Using Vim's built-in package system:>
    mkdir -p ~/.vim/pack/plugins/start
    cd ~/.vim/pack/plugins/start
    git clone https://github.com/Milldrew-Soft/vim-go-bookmark.git
<

After installation, restart Vim or run:>
    :helptags ~/.vim/pack/plugins/start/vim-go-bookmark/doc
<


===============================================================================
MAPPINGS                                             *go-bookmark-mappings*

Basic bookmark operations:~

                                                                 *gb{char}*
gb{char}              Jump to bookmark {char} (0-9, a-z, A-Z)

                                                                *gB{char}*
gB{char}              Set bookmark {char} (0-9, a-z, A-Z)

                                                               *gbbe{char}*
gbbe{char}            Edit note for bookmark {char}

                                                               *gbbd{char}*
gbbd{char}            Delete bookmark {char}

Book management:~

                                                                   *gbbL*
gbbL                  List all available books

                                                                   *gbbS*
gbbS                  Choose default book

                                                                   *gbbE*
gbbE                  Edit note for current selected book

                                                                   *gbbl*
gbbl                  List all bookmarks in selected book

                                                                   *gbbc*
gbbc                  Clear all bookmarks in current book

Book selection:~

                                                                  *gbbs{0-9}*
gbbs{0-9}             Select book 0-9


===============================================================================
FUNCTIONS                                          *go-bookmark-functions*

                                                      *bookmarks#EditBookMarkNote()*
bookmarks#EditBookMarkNote({char})
                Edit the note for bookmark {char}

                                                    *bookmarks#DeleteBookMark()*
bookmarks#DeleteBookMark({char})
                Delete bookmark {char}

                                                   *bookmarks#ClearAllBookMarks()*
bookmarks#ClearAllBookMarks()
                Clear all bookmarks in current book

                                                          *books#listBooks()*
books#listBooks()
                List all available books

                                                       *books#editNote()*
books#editNote({book})
                Edit note for specified book

                                                   *books#chooseDefaultBook()*
books#chooseDefaultBook()
                Choose default book to use

                                                          *GoBookmarksList()*
GoBookmarksList()
                List all bookmarks in selected book


===============================================================================
HIGHLIGHTING                                      *go-bookmark-highlighting*

Bookmarked lines are automatically highlighted when files are opened. Customize
the highlight colors in your vimrc:>
    highlight GoBookmarkHighlight ctermbg=darkblue guibg=#00008b
    highlight GoBookmarkSign ctermfg=white guifg=#ffffff
<

The highlighting is managed by:>
    highlight#AddHighlightToExistingBookmarks()
<


===============================================================================
CONFIGURATION                                    *go-bookmark-configuration*

Available configuration variables:~

                                                      *g:go_bookmark_auto_highlight*
g:go_bookmark_auto_highlight (default: 1)
                Enable/disable automatic highlighting on buffer enter

                                                   *g:bookmark_selection_timeout*
g:bookmark_selection_timeout (default: 1000)
                Timeout in milliseconds for book selection

Example configuration:>
    let g:go_bookmark_auto_highlight = 1
    let g:bookmark_selection_timeout = 1500
<


===============================================================================
TROUBLESHOOTING                                *go-bookmark-troubleshooting*

1. Bookmarks not persisting:
   - Verify write permissions in plugin directory
   - Check for error messages when saving

2. Highlighting not working:
   - Ensure your colorscheme supports custom highlights
   - Verify highlight groups aren't being overridden

3. Mappings not responding:
   - Check for conflicts with :verbose map gb
   - Verify no other plugins use gb/gB prefixes

4. General issues:
   - Enable debug mode with:>
       let g:go_bookmark_debug = 1
   - Check :messages for errors after operations


 vim:tw=78:et:ft=help:norl:

