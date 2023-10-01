# vim-yadm-files

vim-yadm-files is a Vim/Neovim plugin which applies correct filetypes to files
managed by [yadm](https://github.com/TheLocehiliosan/yadm) so that syntax
highlighting and other editor features are applied correctly.

It supports [alternate files](https://yadm.io/docs/alternates) and
[templates](https://yadm.io/docs/templates).

## Installation

vim-yadm-files should work with any Vim/Neovim plugin manager. If you would like
to use [vim-plug](https://github.com/junegunn/vim-plug), for example:

1. [Install vim-plug](https://github.com/junegunn/vim-plug#installation)
2. Add `Plug 'openjck/vim-yadm-files'` to your Vim/Neovim configuration file
3. Run `:PlugInstall`

vim-yadm-files does not come with any built-in documentation and does not
provide any configuration options.

## Usage

### Alternate files

vim-yadm-files supports yadm [alternate files](https://yadm.io/docs/alternates).
For example, when this plugin is enabled, a file with the name
`.gitconfig##distro.Ubuntu` will get the `gitconfig` filetype, which will cause
Vim/Neovim to apply `gitconfig` syntax highlighting and enable other `gitconfig`
features.

### Templates

#### Jinja-based templates

vim-yadm-files supports Jinja-based yadm
[templates](https://yadm.io/docs/templates). For example, when this plugin is
enabled, a file with any of the following names will get the `jinja` filetype:

- `.gitconfig##t`
- `.gitconfig##t.default`
- `.gitconfig##t.j2`
- `.gitconfig##t.j2cli`
- `.gitconfig##t.envtpl`
- `.gitconfig##template`
- `.gitconfig##template.default`
- `.gitconfig##template.j2`
- `.gitconfig##template.j2cli`
- `.gitconfig##template.envtpl`

Note that neither Vim nor Neovim supports the `jinja` filetype out of the box.
For syntax highlighting and other features, install a Jinja plugin like
[vim-jinja2-syntax](https://github.com/glench/vim-jinja2-syntax).

#### esh-based templates

vim-yadm-files sets the `esh` filetype on
[esh](https://github.com/jirutka/esh)-based yadm
[templates](https://yadm.io/docs/templates). For example, when this plugin is
enabled, a file with either of the following names will get the `esh` filetype:

- `.gitconfig##t.esh`
- `.gitconfig##template.esh`

Note that neither Vim nor Neovim supports the `esh` filetype out of the box. I
also cannot find any plugins which provide syntax highlighting or other features
for files with the `esh` filetype. However, if such a plugin is published in the
future, it will be compatible with this plugin.

## Frequently asked questions

### Why not use the extension/e attribute for alternate files?

yadm allows the filenames of alternate files to end with an `extension` or `e`
attribute to make it appear as though it has a certain extension. For example, a
file with the following name will be treated as a Fish script in Vim/Neovim and
most other editors, even without this plugin enabled:

`utils.fish##distro.Ubuntu,extension.fish`

However, I have found that this does not work in Vim/Neovim. For example, Vim
will report that there is no filetype when the following command is run:

`vim -u NONE utils.fish##distro.Ubuntu,extension.fish -c 'set ft?'`

(If `-u NONE` is not passed and a corresponding language plugin is enabled, Vim
may print the correct filetype. For example, in the above example, if `-u NONE`
is not passed and the vim-fish plugin is enabled, Vim will report that the
filetype is `fish`. I assume this is because plugins sometimes detect file
extensions differently than Vim and Neovim core do.)

The `extension`/`e` attribute also does not work in Vim/Neovim for files that do
not have extensions. For example, without this plugin, a file with either of the
following names will not get the `gitconfig` file type:

- `.gitconfig##distro.Ubuntu`
- `.gitconfig##distro.Ubuntu,extension.gitconfig`

### Why not use a modeline?

You _can_ use a [modeline](https://vim.fandom.com/wiki/Modeline_magic) to
suggest that Vim/Neovim set a certain filetype. I just prefer to keep my files
clean.
