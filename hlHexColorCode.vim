let s:prevMatchId = v:null

function! s:ClearColorHighlight(matchid, timer) abort
    call matchdelete(a:matchid)
    let s:prevMatchId = v:null
endfunction

function! s:HighlightHexColorCode(code, duration) abort
    " Check if the code is a valid
    let matchedCode = matchstr(a:code, '#\x\{6\}')

    " Do nothing if not a valid hex 
    if matchedCode ==# ''
	echo 'Not a valid hex color code!'
	return
    endif

    " Clear previous running highlight
    if s:prevMatchId != v:null 
	call timer_stopall()
	call matchdelete(s:prevMatchId)
	let s:prevMatchId = v:null
    endif

    " Introduce a new highlight group specifically for the matched code
    execute 'highlight HexColorCode guifg=#000000 ' . 'guibg=' . matchedCode

    " Highlight the hex color code
    let matchId = matchadd('HexColorCode', matchedCode)
    let s:prevMatchId = matchId

    " Clear matches after 'x' duration(in ms)
    call timer_start(a:duration, function('s:ClearColorHighlight', [matchId]))
endfunction

" Key map
"" Highlight the valid hex color code value under the cursor
noremap <leader>h :call <SID>HighlightHexColorCode(expand('<cword>'), 1500)<cr>

" Testing
" #ff8000
" #80ff00
" #0080ff
" #8000ff
