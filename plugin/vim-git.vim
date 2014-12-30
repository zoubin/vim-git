" Tricks for using git in vim
" Maintainer:	ZOU Bin <zoubin04@gmail.com>
" Contributor: zoubin
" Repository: https://github.com/zoubin/vim-git
" License: MIT

if exists('g:VimGitLoaded') || &cp
  finish
end
let g:VimGitLoaded = 1


" -------------------------------------------------------------
" ----------- git blame ---------------------------------------
fun! Z_GitBlame(mode) range
    if a:mode == 'v'
        let rangeStartLine = line("'<")
        let rangeEndLine = line("'>")
    else
        let rangeStartLine = line(".")
        let rangeEndLine = rangeStartLine
    endif
    exe '!fp=' . resolve(expand("%")) . ';cd $(dirname $fp); git blame -L ' . rangeStartLine . ',' . rangeEndLine . ' $(basename $fp); cd -'
endf

" In visual mode, git blame the selection
vnoremap <unique> <leader>g :call Z_GitBlame('v')<CR>

" In normal mode, git blame the current line
nnoremap <unique> <leader>g :call Z_GitBlame('n')<CR>

" -------------------------------------------------------------
" ----------- git grep ---------------------------------------

function! Z_GitGrep(isLiteral)
    let oldpwd = getcwd()
    let reporoot = system('git rev-parse --show-toplevel')

    let newp = system('dirname ' . shellescape(expand('%')))
    exec 'cd ' . newp
    let newreporoot = system('git rev-parse --show-toplevel')
    exec 'cd ' . newreporoot
    let kw = getreg('"')
    if a:isLiteral == 1
        let target = ' -F ' . escape(kw, ' >()&$')
    else
        if kw[0] == '$'
            let target = '"\' . kw . '\b"'
        else
            let target = '"\b' . kw . '\b"'
        endif
    endif

    silent call s:RunShellCommand('git grep -n ' . target)
    call setreg('/', kw, getregtype('/'))

    let abspath = getcwd()
    exec '4,$s:^:' . abspath . '/'
    exec 'normal 4G'
    exec 'cd ' . oldpwd
endfunction

" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:RunShellCommand(cmdline)
    echo a:cmdline
    let expanded_cmdline = a:cmdline
    for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
    endfor
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'You entered:    ' . a:cmdline)
    call setline(2, 'Expanded Form:  ' .expanded_cmdline)
    call setline(3, substitute(getline(2),'.','=','g'))
    execute '$read !'. expanded_cmdline
    4
endfunction

" In visual mode, press K to git grep the selection in the current repo
vnoremap K y:call Z_GitGrep(1)<CR>
" In normal mode, press K to git grep the word under the cursor
nnoremap K viwy:call Z_GitGrep(0)<CR>

" 在新tab中打开文件. :h CTRL-W_F for more information
nnoremap <C-T> ^<C-W>F

