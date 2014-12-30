vim-git
=======

Tricks for using git in vim.

## Git Blame
You can git blame in both *normal* and *visual* mode:
* normal mode: type `<leader>g`, and you are blaming the current line
* visual mode: type  `<leader>g`, and you are blaming the visual block

## Git Grep
You can git grep in both *normal* and *visual* mode:
* normal mode: type `K`, and you are git greping the word under the cursor
* visual mode: type  `K`, and you are blaming the visual text

In either mode, results are shown in a split window.
Move to any line, and type `CTRL-T`, and a new split window will be opened containing the regarding file. Also, the cursor will be positioned at the regarding line.
