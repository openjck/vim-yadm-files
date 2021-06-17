# vim-yadm-files

vim-yadm-files is a Neovim plugin which applies correct filetypes to files
managed by [yadm](https://github.com/TheLocehiliosan/yadm), which is a tool for
managing dotfiles.

At the moment, only [alternate files](https://yadm.io/docs/alternates) are
supported. For example, a file with the name `.gitconfig##distro.Ubuntu` will
correctly get the `gitconfig` filetype, which will cause Neovim to apply correct
syntax highlighting and more.

## Why not use the extension/e attribute?

YADM allows the filenames of alternate files to end with an `extension` or `e`
key-value pair to coerce editors into treating those files correctly. For
example, a file with the following name will correctly get the `fish` filetype:

    `utils.fish##distro.Ubuntu,extension.fish`

However, I have found that this does not work for files which do not have
extensions. For example, without this plugin, a file with the following name or
any variation of it will not correctly get the `gitconfig` file type:

    `.gitconfig##distro.Ubuntu,extension..gitconfig`
