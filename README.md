vim-git
=======

Tricks for using git in vim.

## Git Blame
Mapping should be completed in vimrc, like:

```
noremap <unique> <leader>g :call git#BlameRange()<CR>

```

Then,
* In normal mode: type `<leader>g`, and you are blaming the current line
* In visual mode: type  `<leader>g`, and you are blaming the visual block

## Git Grep
Mapping should be completed in vimrc, like:

```
nnoremap <unique> K :call git#GrepCursorWord()<CR>
vnoremap <unique> K y:call git#GrepText(getreg('"'))<CR>
nnoremap <unique> <C-T> ^<C-W>F

```

Then,
* In normal mode: type `K`, and you are git greping the word under the cursor
* In visual mode: type  `K`, and you are git greping the visual text

In either mode, results are shown in a split window.
Move to any line, and type `CTRL-T`, and a new split window will be opened containing the regarding file. Also, the cursor will be positioned at the regarding line.

## Usage
After installation, finish the mapping in vimrc, like:

```
" for git blame
noremap <unique> <leader>g :call git#BlameRange()<CR>

" In visual mode, git grep the selection text
vnoremap <unique> K y:call git#GrepText(getreg('"'))<CR>
" In normal mode, git grep the word under the cursor
nnoremap <unique> K :call git#GrepCursorWord()<CR>
" Open in a new window. :h CTRL-W_F for more information
nnoremap <unique> <C-T> ^<C-W>F

```
