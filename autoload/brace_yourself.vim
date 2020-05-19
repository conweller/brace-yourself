let g:brace_dot = 1
function! s:preserve_undo()
    if g:brace_dot
        return "\<C-G>U"
    else
        return ''
    return
endfunction


function! brace_yourself#close_bracket(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:next = l:column

    let l:line = getline('.')

    if l:line[l:next] =~ '[^a-zA-Z0-9\d]' || l:line[l:next] == ''
        call nvim_feedkeys(a:left.a:right.s:preserve_undo()."\<left>", 'n', v:false)
    else
        call nvim_feedkeys(a:left, 'n', v:false)
    endif
endfunction


function! brace_yourself#close_bracket_quote(bracket)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:next = l:column
    let l:prev = l:column-1

    let l:line = getline('.')

    if l:line[l:next] == a:bracket
        call nvim_feedkeys(s:preserve_undo()."\<right>", "n", v:false)
    else
        if (l:prev == -1 || l:line[l:prev] =~ '[^a-zA-Z0-9\d]')
                    \ &&
                    \ (l:line[l:next] =~ '[^a-zA-Z0-9\d]' || l:line[l:next] == '')
                    \ && l:line[l:prev] != a:bracket
            call nvim_feedkeys(a:bracket.a:bracket.s:preserve_undo()."\<left>", 'n', v:false)
        else
            call nvim_feedkeys(a:bracket, "n", v:false)
        endif
    end
endfunction

function! brace_yourself#skip_closing(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:next = l:column

    let l:line = getline('.')

    if l:line[l:next] == a:right
        call nvim_feedkeys(s:preserve_undo()."\<right>", "n", v:false)
    else
        call nvim_feedkeys(a:right, 'n', v:false)
    end
endfunction

function! brace_yourself#delete_bracket(left, right)
    let [l:row, l:column] =  nvim_win_get_cursor(0)
    let l:next = l:column
    let l:prev = l:column-1

    let l:prev_line = getline(l:row-1)
    let l:line = getline('.')
    let l:next_line = getline(l:row+1)

    if l:line[l:prev] == a:left && l:line[l:next] == a:right
        call nvim_feedkeys("\<delete>\<bs>", "n", v:false)
        return v:true
    elseif l:line =~ '^\s*$' && l:prev_line =~ a:left.'$' && l:next_line =~ '^\s*'.a:right
        let l:new_next_line = l:next_line[match(l:next_line, a:right):]
        call setline(l:row+1, l:new_next_line)
        call nvim_feedkeys("\<c-t>\<c-u>\<down>\<bs>\<bs>", "n", v:false)
        return v:true
    else
        return v:false
    end
endfunction


function! brace_yourself#expand(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:next = l:column
    let l:prev = l:column-1

    let l:line = getline('.')

    if l:line[l:prev] == a:left && l:line[l:next] == a:right
        " call nvim_feedkeys("\<c-j>\<c-g>k\<c-j>\<c-t>\<c-u>", "n")
        " call nvim_feedkeys("\<c-j>\<c-g>k\<c-j>", "n")
        " call nvim_feedkeys("\<c-j>\<Up>\<end>\<c-j>", "n")
        call nvim_feedkeys("\<c-j>\<m-O>", "n", v:false)
        return v:true
    else
        return v:false
    end
endfunction

function! brace_yourself#expand_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        if brace_yourself#expand(left, right)
            return v:true
        end
    endfor
    call nvim_feedkeys("\<c-j>", 'n', v:false)
    return v:false
endfunction

function! brace_yourself#delete_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        if brace_yourself#delete_bracket(left, right)
            return v:true
        end
    endfor
    call nvim_feedkeys("\<bs>", 'n', v:false)
    return v:false
endfunction
