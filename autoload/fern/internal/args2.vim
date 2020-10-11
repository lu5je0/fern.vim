function! fern#internal#args2#fargs(expr) abort
  let s = split(a:expr, '[^\\]\zs\s\|\\\\\zs\s')
  call map(s, { _, v -> substitute(v, '\\\(\s\)', '\1', 'g') })
  call map(s, { _, v -> substitute(v, '\\\\', '\\', 'g') })
  return s
endfunction

function! s:pop(expr, name, ...) abort
  let m = matchstrpos(a:expr, printf('\%%(^\|\s\)-%s=\%%(\\\s\|\S\)*', a:name))
  if m[0] !=# ''
    let v = matchstr(m[0], printf('\s\?-%s=\zs.*', a:name))
    let v = substitute(v, '\\\(\s\)', '\1', 'g')
    let v = substitute(v, '\\\\', '\\', 'g')
    let expr = a:expr[: m[1] - 1] . a:expr[m[2]: ]
    return [expr, v]
  endif
  let m = matchstrpos(a:expr, printf('\%%(^\|\s\)-%s\>', a:name))
  if m[0] !=# ''
    let expr = a:expr[: m[1] - 1] . a:expr[m[2]: ]
    return [expr, v:true]
  endif
  let default = a:0 ? a:1 : v:false
  return [a:expr, default]
endfunction

echomsg string(s:pop('asdr -name=hello\ world; -name2 -asdf-name=asdf', 'name'))
echomsg string(s:pop('asdr -name=hello\ world; -name2 -asdf-name=asdf', 'name2'))
echomsg string(s:pop('asdr -name=hello\ world; -name2 -asdf-name=asdf', 'name3'))
