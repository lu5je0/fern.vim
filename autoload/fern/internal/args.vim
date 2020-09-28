let s:Args = vital#fern#import('App.Args')

function! fern#internal#args#set(args, name, value) abort
  return s:Args.set(a:args, a:name, a:value)
endfunction

function! fern#internal#args#pop(args, name, default) abort
  return s:Args.pop(a:args, a:name, a:default)
endfunction

function! fern#internal#args#throw_if_dirty(args) abort
  return s:Args.throw_if_dirty(a:args, '[fern] ')
endfunction
