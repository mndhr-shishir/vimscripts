function! s:HandleResponse(lineno, channel, msg) abort
    let res = a:msg->json_decode()
    let colorName = tolower(res['name'])
    
    " Append color name to the contents of that line number
    let lineContent = getline(a:lineno)
    call setline(a:lineno, lineContent . ' ' . printf(&commentstring, ' ' . colorName))
endfunction

function! s:AppendColorName(lineno, hexCode) abort
    let code = matchstr(a:hexCode, '\x\{6\}')
    if code ==# ''
	echo 'Not a valid hex color code!'
	return 
    endif
    
    let query = 'https://colornames.org/search/json/?hex=' . code
    let req = 'curl -s -H "Accept: application/json"' . ' ' . query
    let job = job_start(req, {
		\ 'out_cb': function('s:HandleResponse', [a:lineno])
		\ })
endfunction

noremap <plug>(AppendColorName) :source % <bar> call <SID>AppendColorName(line('.'), expand('<cword>'))<cr>

" Testing
" #CD5C5C
" #F08080
" #FA8072
" #E9967A
" #FFA07A
" #ff8000
" #80ff00
" #0080ff
" #8000ff
