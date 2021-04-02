let s:undo_str = "\<C-G>U"

function! s:is_alpha_or_num(char)
    return !(a:char =~ '\k\|"\|''')
endfunction

function! brace_yourself#close_bracket(left, right)
    let [_, _, l:column, _] =  getpos('.')
    let l:column -= 1
    let l:line = getline('.')

    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]


    if l:prev_char == "\\"
        return a:left . "\\" . a:right . s:undo_str . "\<left>" . s:undo_str . "\<left>"
    elseif s:is_alpha_or_num(l:next_char) || l:next_char == ''
        return a:left . a:right . s:undo_str . "\<left>"
    else
        return a:left
    endif
endfunction


function! brace_yourself#close_bracket_quote(bracket)
    let [_, _, l:column, _] =  getpos('.')
    let l:column -= 1
    let l:line = getline('.')

    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]
    let l:pprev_char = l:line[l:column-2]


    if l:next_char == a:bracket
        return s:undo_str."\<right>"
    elseif l:pprev_char == a:bracket && l:prev_char == a:bracket
        return a:bracket . a:bracket  . a:bracket  . a:bracket . s:undo_str . "\<left>" . s:undo_str . "\<left>" . s:undo_str . "\<left>"
    elseif l:prev_char == "\\"
        return a:bracket . "\\" . a:bracket . s:undo_str . "\<left>" . s:undo_str . "\<left>"
    else
        if (l:column-1 == -1 || s:is_alpha_or_num(l:prev_char))
                    \ &&
                    \ (s:is_alpha_or_num(l:next_char) || l:next_char == '')
                    \ && l:prev_char != a:bracket
            return a:bracket . a:bracket . s:undo_str . "\<left>"
        else
            return a:bracket
        endif
    end
endfunction

function! brace_yourself#skip_closing(left, right)
    let [_, _, l:column, _] =  getpos('.')
    let l:column -= 1
    let l:line = getline('.')
    let l:next_char = l:line[l:column]

    if l:next_char == a:right
        return s:undo_str . "\<right>"
    else
        return a:right
    end
endfunction

function! brace_yourself#delete_bracket(left, right)
    let [_, l:row, l:column, _] =  getpos('.')
    let l:column -= 1
    let l:line = getline('.')

    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]
    let l:nnext_char = l:line[l:column+1]
    let l:pprev_char = l:line[l:column-2]
    let l:prev_line = getline(l:row-1)
    let l:next_line = getline(l:row+1)

    if l:prev_char == a:left && l:next_char == a:right
        return 1
    elseif l:pprev_char == "\\" && l:prev_char == a:left && l:next_char == "\\" && l:nnext_char == a:right
        return 3
    elseif l:line =~ '^\s*$' && l:prev_line =~ escape(a:left, '*.$^').'$' && l:next_line =~ '^\s*'.escape(a:right, '*.$^')
        return 2
    elseif l:line =~ '^\s*$' && l:prev_line =~ escape("\\\\" . a:left, '*..$^').'$' && l:next_line =~ '^\s*'.escape("\\\\" . a:right, '*..$^')
        return 2
    else
        return -1
    end
endfunction


function! brace_yourself#expand(left, right)
    let [_, _, l:column, _] =  getpos('.')
    let l:column -= 1
    let l:line = getline('.')
    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]
    let l:nnext_char = l:line[l:column+1]
    let l:pprev_char = l:line[l:column-2]


    if l:prev_char == a:left && l:next_char == a:right
        return v:true
    elseif l:pprev_char == "\\" && l:prev_char == a:left && l:next_char == "\\" && l:nnext_char == a:right
        return v:true
    else
        return v:false
    end
endfunction

function! brace_yourself#expand_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        if brace_yourself#expand(left, right)
            return "\<c-j>\<up>\<end>\<c-j>"
        end
    endfor
    return "\<c-j>"
endfunction

function! brace_yourself#delete_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        let l:case = brace_yourself#delete_bracket(left, right)
        if l:case == 1
            return "\<delete>\<bs>"
        elseif l:case == 2
            return  "0\<c-d>\<down>0\<c-d>\<bs>\<bs>"
        elseif l:case == 3
            return  "\<delete>\<delete>\<bs>\<bs>"
        end
    endfor
    return "\<bs>"
endfunction
