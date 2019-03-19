function! brace_yourself#match_it(brac1, brac2)
	let [_b, line, col, _o] = getpos('.')

	let curline = getline(line)

	let shift_dir = "\<left>"
	let append_string = a:brac1 . a:brac2
	if (a:brac1 == a:brac2)
		if (curline[col-1]==a:brac2)
			let shift_dir = "\<right>"
			let append_string = ""
		endif
	endif

	let shift = ""
	for i in range(0, strlen(a:brac2)-1)
		let shift = shift . shift_dir
	endfor
	return append_string . shift
endfunction


function! brace_yourself#move_right(brac1, brac2)
	let [_b, line, col, _o] = getpos('.')
	let curline = getline(line)

	if (curline[col-1]==a:brac2)
		let shift = ""
		for i in range(0, strlen(a:brac2)-1)
			let shift = shift . "\<right>"
		endfor
		return shift
	else
		return a:brac2
	endif
endfunction

function! brace_yourself#do_we_expand(brac1,brac2)
	let [_b, line, col, _o] = getpos('.')
	let curline = getline(line)
	return curline[col-1-strlen(a:brac1):col-2]==a:brac1 &&
				\curline[col-1:col-1+strlen(a:brac2)-1]==a:brac2
endfunction


function! brace_yourself#do_we_expand_all(arrays)
	let [_b, line, col, _o] = getpos('.')
	let curline = getline(line)
	let expand = 0
	for array in a:arrays
		if brace_yourself#do_we_expand(array[0], array[1])
			let brackets = array
			let expand = 1
			break
		endif
	endfor

	if expand
		return "\<c-j>\<up>\<c-o>A\<c-j>"
	else
		return "\<c-j>"
	endif
endfunction


function! brace_yourself#do_we_unexpand(brac1, brac2)
	let [_b, line, col, _o] = getpos('.')
	let prevline = getline(line-1)
	let nextline = getline(line+1)
	let curline = getline(line)

	if len(split(curline)) != 0
		return 0
	endif

	if len(split(prevline)) >0 && a:brac1 == split(prevline)[-1][-strlen(a:brac1):]
		if len(split(nextline))>0
			return split(nextline)[0][0:strlen(a:brac2)-1]==a:brac2
		endif
	endif
	return 0
endfunction

function! brace_yourself#do_we_delete(brac1, brac2)
	let [_b, line, col, _o] = getpos('.')
	let curline = getline(line)
	let prevline = getline(line-1)
	let nextline = getline(line+1)
	let match = 1
	for i in range(0,strlen(a:brac1)-1)
		if curline[col-2-i] != a:brac1[strlen(a:brac1)-1-i]
			let match = 0
		endif
	endfor
	for i in range(0,strlen(a:brac2)-1)
		if curline[col-1+i] != a:brac2[i]
			let match = 0
		endif
	endfor
	return match
endfunction

function! brace_yourself#do_we_delete_all(arrays)
	let delete_both = 0
	for array in a:arrays
		if brace_yourself#do_we_delete(array[0], array[1])
			let brackets = array
			let delete_both = 1
			break
		elseif brace_yourself#do_we_unexpand(array[0], array[1])
			return "\<c-o>\"_dd\<c-o>I \<left>\<c-o>vk$\"_d"
		endif
	endfor

	if delete_both == 1
		let delete_input = ""
		for i in range(0, strlen(brackets[1])-1)
			let delete_input = delete_input . "\<Delete>"
		endfor
		for i in range(0, strlen(brackets[0])-1)
			let delete_input = delete_input . "\<C-h>"
		endfor
		return delete_input
	else
		return "\<C-h>"
	endif
endfunction

function! brace_yourself#set_maps(brackets)
	inoremap <silent><buffer><expr> <Backspace> brace_yourself#do_we_delete_all(brackets)
	inoremap <silent><buffer><expr> <CR> brace_yourself#do_we_expand_all(brackets)
	for i in a:brackets
		if (len(i) == 3)
			let trigger = i[2]
		else
			let trigger = i[0]
		endif
		if (i[0] =~ "\"" || i[1] =~ "\"")
			execute "inoremap <silent><buffer><expr> "
						\ . trigger .
						\" brace_yourself#match_it('".
						\i[0] . "','".  i[1] . "')"
		else
			execute "inoremap <silent><buffer><expr> "
						\. trigger .
						\" brace_yourself#match_it(\"".
						\i[0] . "\",\"".  i[1] . "\")"
		endif
		if ((trigger != i[1]) && strlen(i[1]) == 1 )
			execute "inoremap <silent><buffer><expr> "
						\. i[1] .
						\" brace_yourself#move_right(\"".
						\i[0] . "\",\"".  i[1] . "\")"
		endif
	endfor
endfunction
