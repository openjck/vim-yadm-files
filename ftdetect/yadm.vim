" If this is a YADM alternate file, set the filetype based on the name of the
" file with the suffix removed.
"
" A YADM alternate file is a file which ends with a suffix of two pound
" characters followed by at least one of several keywords. For example:
"
"   .gitconfig##distro.Ubuntu
"
" This function figures out what the name of the file would be with the suffix
" removed (in this case, .gitconfig) and tells the editor to instead use that
" name to determine the filetype.
"
" For more information about YADM alternate files, see the YADM documentation:
"
" https://yadm.io/docs/alternates
function! s:HandlePossibleYADMAlternateFile()
  " The file name not including the path (:t) of the current file (%)
  let l:filename = expand("%:t")

  if s:IsYADMAlternateFile(l:filename)

    " For example, .gitconfig
    let l:filename_without_suffix = split(l:filename, '##')[0]

    " Detect the filetype based on the name of the file with the suffix
    " removed.
    "
    " Note that this method works better than simply setting the filetype to
    " be equal to the value of the extension[1] because files with certain
    " extensions need to be processed before their filetypes can be
    " determined. For example, with this method, files with the "jsx"
    " extension correctly get the "javascriptreact" file type.
    "
    " For more information, see this Stack Overflow answer:
    " https://vi.stackexchange.com/a/29271/28836
    "
    " [1] execute 'set filetype=' . extension
    execute 'doautocmd filetypedetect BufRead ' . l:filename_without_suffix

  endif
endfunction

function! s:IsYADMAlternateFile(filename)
  " Valid suffix attributes. These are listed in the YADM documentation:
  " https://yadm.io/docs/alternates
  "
  " "extension" and "e" are ommitted because they themselves serve to coerce
  " editors into treating the alternate file as if it had a particular
  " extension. However, I have found that this only coerces Neovim to treat the
  " file differently if it would normally have an extension. See README.md for
  " more information.
  let l:attributes = [
  \ 'template', 't',
  \ 'user', 'u',
  \ 'distro', 'd',
  \ 'os', 'o',
  \ 'class', 'c',
  \ 'hostname', 'h',
  \ 'default',
  \]

  for l:attribute in l:attributes
    if a:filename =~ '##' . l:attribute
      return 1 " true
    endif
  endfor
  return 0 " false
endfunction

augroup filetypedetect
  autocmd BufRead,BufNewFile *##* call s:HandlePossibleYADMAlternateFile()
augroup END
