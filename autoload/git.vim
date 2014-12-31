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

fun! git#Blame(start, end) abort
    " should work for symbolic links
    let filename = resolve(expand("%"))
    let cmd = 'cd $(dirname ' . filename . ')'
    let cmd .= ';git blame -L ' . a:start . ',' . a:end . ' $(basename ' . filename . ')'
    let cmd .= ';cd -'
    silent call s:RunShellCommand(cmd)
endf

fun! git#BlameRange() abort range
    silent call git#Blame(a:firstline, a:lastline)
endf

" Grep whatever content given. Escaping should be done before
function! git#Grep(content) abort
    let oldpwd = getcwd()
    let reporoot = system('git rev-parse --show-toplevel')

    " should work for files in another repo
    let newp = system('dirname ' . shellescape(expand('%')))
    exec 'cd ' . newp
    let newreporoot = system('git rev-parse --show-toplevel')
    exec 'cd ' . newreporoot

    silent call s:RunShellCommand('git grep -n ' . a:content)

    exec '4,$s:^:' . getcwd() . '/'
    exec 'normal! 4G'
    exec 'cd ' . oldpwd
endfunction

" Grep the word under cursor
function! git#GrepCursorWord() abort
    let kw = expand("<cword>")
    if kw[0] == '$'
        " hack for words beginning with a dollar sign
        let target = '"\' . kw . '\b"'
        let kw = kw . '\>'
    else
        let target = '"\b' . kw . '\b"'
        let kw = '\<' . kw . '\>'
    endif
    silent call git#Grep(target)

    " highlight
    call setreg('/', kw, getregtype('/'))
endfunction

" Grep whatever text given literally
function! git#GrepText(text) abort
    " could be arbitrary text
    let kw = escape(a:text, ' ">()]&$' . "'")
    " F option makes grep literal
    silent call git#Grep(' -F ' . kw)

    " highlight
    call setreg('/', escape(a:text, ']'), getregtype('/'))
endfunction
