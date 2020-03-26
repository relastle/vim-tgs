<h1 align="center">vim-tgs</h1>

<p align="center">Stylish tag operation</p>

## 1. Installation

Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'relastle/vim-tgs'
```

vim-tgs requires

- `if_pyth` (vim) or `pynvim` (nvim).
- https://github.com/junegunn/fzf is also bundled.

## 2. Usage

### 2.1 Commands

Please refer [doc](./doc/vim-tgs.txt) for full documentation.
Some demonstrations are shown here.

#### :TgsList

List all tag list using active tag file.
This command can be used in a very similar way to :Tags
command from https://github.com/junegunn/fzf.vim.

![TgsList demo](https://user-images.githubusercontent.com/6816040/77666322-2ac44380-6fc4-11ea-8630-fec4e2ead9bd.png)

#### :Tgs

Jump to current word definition using tags.
If only one candidate is found, it make you jump to it.
If multiple candidates are found, you can select using fzf interface.

If you want to repace default tag jump key to this fucntion, try
```vim
nnoremap <C-]> :Tgs<CR>
```

![Tgs demo](https://user-images.githubusercontent.com/6816040/77666763-b342e400-6fc4-11ea-9d1f-289e4503a982.png)

## 3. Feature roadmap

- [x] More colorful version of :Tags (c.f. https://github.com/junegunn/fzf.vim)
- [x] Provide command for the purpose of replacing defualt tag jump ( <kbd>Ctrl</kbd> + <kbd>]</kbd> )
- [ ] Push to tag stach when jumping to tag using :TgsList

## 4. Note

#### :construction:

- Please note that any destructive change (backward incompatible) can be done without any announcement.
- This plugin is in a very early stage of development. Feel free to report problemcs and feature requests, or make PRs.

## 5. Credits

Great thanks to the following projects

- https://github.com/junegunn/fzf (Full dependency)
- https://github.com/junegunn/fzf.vim (Some code inspiration)


## 5. [LICENSE](./LICENSE)

MIT
