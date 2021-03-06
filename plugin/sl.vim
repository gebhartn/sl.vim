" Syntax highlight group
function! SyntaxItem() abort
    let l:syntaxname = synIDattr(synID(line("."), col("."), 1), "name")

    if l:syntaxname != ""
        return printf(" %s ", l:syntaxname)
    else
        return ""
    endif
endfunction

" Ale linter status
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    if l:counts.total == 0
        return ""
    else
        return printf(" [%d] ", l:counts.total)
    endif
endfunction

" Readonly flag check
function! ReadOnly() abort
    if &readonly || !&modifiable
        return " [RO] "
    else
        return ""
    endif
endfunction

" Modified flag check
function! Modified() abort
    if &modified
        return " [+] "
    else
        return ""
    endif
endfunction

" File type
function! FileType() abort
    if len(&filetype) == 0
        return "text"
    endif

    return tolower(&filetype)
endfunction

" NERDTree statusline
let NERDTreeStatusline="%2* nerdtree %5*"

" Always show statusline
set laststatus=2

" Format active statusline
function! ActiveStatusLine() abort
    " Reset statusline
    let l:statusline=""

    " Filename
    let l:statusline.="%1* %t "

    " Show if file is readonly
    let l:statusline.="%2*%{ReadOnly()}"

    " ALE lint errors
    let l:statusline.="%2*%{LinterStatus()}"

    " Show if file has been modified
    let l:statusline.="%2*%{Modified()}"

    " Show syntax identifier
    let l:statusline.="%2*%{SyntaxItem()}"

    " Split right
    let l:statusline.="%5*%="

    " Line and column
    let l:statusline.="%2* %l:%c/%L "

    " File type
    let l:statusline.="%1* %{FileType()} "

    " Done
    return l:statusline
endfunction

" Format inactive statusline
function! InactiveStatusLine() abort
    " Reset statusline
    let l:statusline=""

    " Filename
    let l:statusline.="%3* %t "

    " Blank
    let l:statusline.="%5*"

    " Done
    return l:statusline
endfunction

" Set active statusline
function! SetActiveStatusLine() abort
    if &ft ==? 'nerdtree'
        return
    endif

    setlocal statusline=
    setlocal statusline+=%!ActiveStatusLine()
endfunction

" Set inactive statusline
function! SetInactiveStatusLine() abort
    if &ft ==? 'nerdtree'
        return
    endif

    setlocal statusline=
    setlocal statusline+=%!InactiveStatusLine()
endfunction

" Autocmd statusline
augroup statusline
    autocmd!
    autocmd WinEnter,BufEnter * call SetActiveStatusLine()
    autocmd WinLeave,BufLeave * call SetInactiveStatusLine()
augroup end
