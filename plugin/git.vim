" Tricks for using git in vim
" Maintainer:	ZOU Bin <zoubin04@gmail.com>
" Contributor: zoubin
" Repository: https://github.com/zoubin/vim-git
" License: MIT

" mapping examples
" -------------------------------------------------------------
" ----------- git blame ---------------------------------------

" noremap <unique> <leader>g :call git#BlameRange()<CR>

" -------------------------------------------------------------
" ----------- git grep ---------------------------------------


" In visual mode, press K to git grep the selection in the current repo
" vnoremap <unique> K y:call git#GrepText(getreg('"'))<CR>
" In normal mode, press K to git grep the word under the cursor
" nnoremap <unique> K :call git#GrepCursorWord()<CR>

" 在新tab中打开文件. :h CTRL-W_F for more information
" nnoremap <unique> <C-T> ^<C-W>F

