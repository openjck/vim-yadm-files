# vim-yadm-files

vim-yadm-files is a Vim/Neovim plugin which applies correct filetypes to files
managed by [yadm](https://github.com/TheLocehiliosan/yadm), which is a tool for
managing dotfiles.

At the moment, only [alternate files](https://yadm.io/docs/alternates) are
supported. For example, a file with the name `.gitconfig##distro.Ubuntu` will
correctly get the `gitconfig` filetype, which will cause Vim/Neovim to apply
correct syntax highlighting and more.

## Why not use the extension/e attribute?

YADM allows the filenames of alternate files to end with an `extension` or `e`
attribute-value pair to coerce editors into treating those files correctly. For
example, a file with the following name will correctly get the `fish` filetype:

    utils.fish##distro.Ubuntu,extension.fish

However, I have found that this does not work for files which do not have
extensions. For example, without this plugin, files with either of the following
names or will not correctly get the `gitconfig` file type:

    .gitconfig##distro.Ubuntu
    .gitconfig##distro.Ubuntu,extension.gitconfig

## Why not use a Vim modeline?

You can use a [modeline](https://vim.fandom.com/wiki/Modeline_magic) to coerce
Vim/Neovim into setting the correct filetype. I just prefer to keep my files
clean.
