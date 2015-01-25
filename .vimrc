function! g:SendRight(...) range
  if a:0 > 0
    let start = a:1
    let end = a:1
  else
    let start = a:firstline
    let end = a:lastline
  endif

  for line in getline(start, end)
    " every quote with a slash in front of it gets double-slashed
    let line = substitute(line, '\\"', '\\\\"', 'g')
    let line = substitute(line, '"', '\\"', 'g')
    execute('silent !tmux send-keys -l -t right "' . line . '"')
    execute("silent !tmux send-keys -t right C-m")
  endfor
  redraw!
endfunction

vmap <F6> :call g:SendRight()<CR>
nmap <F6> :call g:SendRight(".")<CR>
