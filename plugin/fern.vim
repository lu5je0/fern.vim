if exists('g:loaded_fern')
  finish
elseif (!has('nvim') && !has('patch-8.1.0994'))
  " NOTE:
  " At least https://github.com/vim/vim/releases/tag/v8.1.0994 is required
  " thus minimum working version is 8.1.0994. Remember that minimum support
  " version is not equal to this.
  echohl WarningMsg
  echo '[fern] Fern does not work on this version of Vim.'
  echohl None
  finish
elseif exists('+shellslash') && &shellslash
  " NOTE:
  " https://github.com/lambdalisue/fern.vim/issues/102
  echohl WarningMsg
  echo '[fern] Fern does not work with "shellslash" option.'
  echohl None
  finish
endif
let g:loaded_fern = 1
let g:fern_loaded = 1 " Obsolete: For backward compatibility

command! -bar -nargs=*
      \ -complete=customlist,fern#internal#command#fern#complete
      \ Fern
      \ call fern#internal#command#fern#command(<q-mods>, [<f-args>])

command! -bar -nargs=*
      \ -complete=customlist,fern#internal#command#do#complete
      \ FernDo
      \ call fern#internal#command#do#command(<q-mods>, [<f-args>])

function! s:BufReadCmd() abort
  if exists('b:fern')
    return
  endif
  call fern#internal#viewer#init()
        \.catch({ e -> fern#logger#error(e) })
endfunction

augroup fern_internal
  autocmd! *
  autocmd BufReadCmd fern://* nested call s:BufReadCmd()
  autocmd SessionLoadPost fern://* nested call s:BufReadCmd()
augroup END
