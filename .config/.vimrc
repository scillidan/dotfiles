set tabstop=4
set shiftwidth=4
set noexpandtab

" For Windows
if has('win32')
  " clipboard
  if executable('win32yank.exe')
    let g:clipboard = {
          \   'name': 'win32yank',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
    set clipboard=unnamedplus
    vnoremap <C-c> "+y
    vnoremap <C-v> "+p
  else
    " Fallback: Use Vim's built-in clipboard (for GVim)
    if has('gui_running')
      set clipboard=unnamed
    endif
  endif

  vnoremap y "+y
  nnoremap Y "+y$
  nnoremap <leader>p "+p
  vnoremap <leader>p "+p
endif