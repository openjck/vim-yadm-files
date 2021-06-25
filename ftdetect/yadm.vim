" If this is a yadm alternate file, set the filetype based on the name of the
" file with the suffix removed.
"
" A yadm alternate file is a file which ends with a suffix of two pound
" characters followed by at least one of several keywords. For example:
"
"   .gitconfig##distro.Ubuntu
"
" This function figures out what the name of the file would be with the suffix
" removed (in this case, .gitconfig) and tells the editor to instead use that
" name to determine the filetype.
"
" For more information about yadm alternate files, see the yadm documentation:
"
" https://yadm.io/docs/alternates
function! s:HandlePossibleAlternateFile()
  " For the current file (%), the filename only without the path (:t)
  let l:filename = expand("%:t")

  " If this alterante file is a template file, which is really a special kind of
  " alternate file, don't do anything. Template files are handled differently in
  " the augroup.
  if s:IsTemplateFile(l:filename) | return | endif

  " If this alternate file includes an extension/e attribute, don't do anything,
  " so that the extension/e attribute takes precedence.
  "
  " This ensures that, for example, if the vim-fish plugin is installed, a file
  " with the following name is given the fish filetype, as the author clearly
  " intends by the inclusion of the extension/e attribute.
  "
  " See the README for more information.
  "
  " script.sh##distro.Ubuntu,extension.fish
  if s:IsAlternateFileWithExtensionAttribute(l:filename) | return | endif

  if s:IsAlternateFile(l:filename)
    echom(l:filename)
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
    " [1] "execute 'set filetype=' . extension" or
    "     "execute 'setfiletype ' . extension"
    execute 'doautocmd filetypedetect BufRead ' . l:filename_without_suffix
  endif
endfunction

" Return true if the file is a yadm template file.
"
" Note that ##t (for example, .gitconfig##t) is a valid suffix for a template
" file.
"
" The =~? operator determines whether a regex matches case-insensitively. I do
" not know for certain, but I assume that yadm supports capitalized attribute
" names on case-insensitive systems like Mac and Windows.
"
" See ":help expr-=~?" for more information.
function! s:IsTemplateFile(filename)
  return a:filename =~? '.*##t'
endfunction

" Return true if the file is a yadm alternate file which contains an extension/e
" attribute.
function! s:IsAlternateFileWithExtensionAttribute(filename)
  return a:filename =~? '.*\(##\|##.*,\)\(extension\|e\)\.'
endfunction!

" Return true if the file is a yadm alternate file.
"
" Valid suffix attributes are listed in the yadm documentation:
" https://yadm.io/docs/alternates
"
" Note that extension/e and template/t are included here, even though files with
" those attributes are excluded in the s:HandlePossibleAlternateFile function,
" just in case this function ever needs to be used for another purpose.
function! s:IsAlternateFile(filename)
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
    " According to the yadm documentation, the template/t attribute may legally
    " be followed either by a dot or by nothing. That is, all of the following
    " filenames are valid:
    "
    " .gitignore##template
    " .gitignore##t
    " .gitignore##template.envtpl
    " .gitignore##t.envtpl
    "
    " When the template/t attribute is followed by nothing, as in the first two
    " examples, the default template processor is used.
    "
    " According to the yadm documentation, all other attributes must be followed
    " by a dot.
    if (l:attribute == 't' || l:attribute == 'template') && a:filename =~? '##' . l:attribute . '\(\.\|$\)'
      return 1
    elseif a:filename =~? '##' . l:attribute . '\.'
      return 1 " true
    endif
  endfor

  return 0 " false
endfunction

" There are many ways to set filetypes in Vim/Neovim. It is not obvious to me
" which method would be best in this situation, but I think this approach makes
" sense.
"
" This essentially follows the guidance in part A of the new-filetype
" documentation.[1] I think this is the right guidance to follow because we do
" want to overrule all default file type checks. The correct filetype depends
" completely on the suffix, which Vim/Neovim knows anything about.
"
" It seems that part C or part D of the new-filetype documentation could be
" appropriate, except that, I assume, they should only be followed if an earlier
" part (like part A) is not applicable.
"
" Ultimately, setting filetypes in Vim/Neovim is somewhat confusing. I'm trying
" to use the right approach here, but I doubt any of this will matter much in
" practice. If it does, someone can file a bug.
"
" [1] Run ":help new-filetype" and scroll to part A
"
" See also the following Stack Overflow answer to my question about this:
" https://vi.stackexchange.com/a/31642/28836
autocmd BufRead,BufNewFile *##* call s:HandlePossibleAlternateFile()
autocmd BufRead,BufNewFile *##{t,template},*##{t,template}.{default,j2,j2cli,envtpl} set filetype=jinja
autocmd BufRead,BufNewFile *##{t,template}.esh set filetype=esh
