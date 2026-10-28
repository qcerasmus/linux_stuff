function! s:RunSmall(cmd) abort
	let output = systemlist(a:cmd)
	let status = v:shell_error

	botright 8new
	setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
	call setline(1, empty(l:output) ? ['(no output'] : l:output)

	if status != 0
		call append('$', ['', '[exit code: ' . l:status . ']'])
	endif
	setlocal nomodifiable
endfunction

command! -nargs=+ RunSmall call <SID>RunSmall(<q-args>)

