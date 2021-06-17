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

    " If this file has a name which includes an "extension"/"e" attribute-value
    " pair, dont do anything, so as to allow the "extension"/"e" attribute to
    " have its intended effect
    "
    " This ensures that, for example, a file with the following name is given
    " the fish filetype as the author clearly intends by the enclusion of the
    " "extension" attribute-value pair:
    "
    " script.sh##distro.Ubuntu,extension.fish
    if s:IsYADMAlternateFileWithExtensionAttribute(l:filename)
      return
    endif

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

" Return true if the file is a YADM alternate file and it contains an
" extension/e attribute-value pair
function! s:IsYADMAlternateFileWithExtensionAttribute(filename)
  " =~# is the "regex matches" operator
  if a:filename =~# '\(##\|##.*,\)\(extension\|e\)\.'
    return 1 " true
  endif
  return 0 " false
endfunction

function! s:IsYADMAlternateFile(filename)
  " Valid suffix attributes. These are listed in the YADM documentation:
  " https://yadm.io/docs/alternates
  let l:attributes = [
  \ 'template', 't',
  \ 'user', 'u',
  \ 'distro', 'd',
  \ 'os', 'o',
  \ 'class', 'c',
  \ 'hostname', 'h',
  \ 'default',
  \ 'extension', 'e',
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
