let s:Config = vital#fern#import('Config')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

let s:STATUS_NONE = g:fern#internal#node#STATUS_NONE
let s:STATUS_COLLAPSED = g:fern#internal#node#STATUS_COLLAPSED

function! fern#renderer#default#render(nodes, marks) abort
  let options = {
        \ 'leading': g:fern#renderer#default#leading,
        \ 'root_symbol': g:fern#renderer#default#root_symbol,
        \ 'leaf_symbol': g:fern#renderer#default#leaf_symbol,
        \ 'expanded_symbol': g:fern#renderer#default#expanded_symbol,
        \ 'collapsed_symbol': g:fern#renderer#default#collapsed_symbol,
        \ 'marked_symbol': g:fern#renderer#default#marked_symbol,
        \ 'unmarked_symbol': g:fern#renderer#default#unmarked_symbol,
        \}
  let base = len(a:nodes[0].__key)
  let Profile = fern#profile#start("fern#renderer#default#render")
  return s:AsyncLambda.map(copy(a:nodes), { v, -> s:render_node(v, a:marks, base, options) })
        \.finally({ -> Profile() })
endfunction

function! fern#renderer#default#index(lnum) abort
  return a:lnum - 1
endfunction

function! fern#renderer#default#lnum(index) abort
  return a:index + 1
endfunction

function! fern#renderer#default#syntax() abort
  syntax clear
  syntax match FernRoot   /\%1l.*/
  syntax match FernLeaf   /^\s*|  /
  syntax match FernBranch /^\s*|[+-] .*/
  syntax match FernMarked /^* .*/
endfunction

function! fern#renderer#default#highlight() abort
  highlight default link FernRoot   Directory
  highlight default link FernLeaf   Directory
  highlight default link FernBranch Directory
  highlight default link FernMarked Title
endfunction

function! s:render_node(node, marks, base, options) abort
  let prefix = index(a:marks, a:node.__key) is# -1
        \ ? a:options.unmarked_symbol
        \ : a:options.marked_symbol
  let level = len(a:node.__key) - a:base
  if level is# 0
    return prefix . a:options.root_symbol . a:node.label
  endif
  let leading = repeat(a:options.leading, level - 1)
  let symbol = a:node.status is# s:STATUS_NONE
        \ ? a:options.leaf_symbol
        \ : a:node.status is# s:STATUS_COLLAPSED
        \   ? a:options.collapsed_symbol
        \   : a:options.expanded_symbol
  return prefix . leading . symbol . a:node.label
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'leading': ' ',
      \ 'root_symbol': '',
      \ 'leaf_symbol': '|  ',
      \ 'collapsed_symbol': '|+ ',
      \ 'expanded_symbol': '|- ',
      \ 'marked_symbol': '* ',
      \ 'unmarked_symbol': '  ',
      \})