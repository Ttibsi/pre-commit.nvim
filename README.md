# pre-commit.nvim

Neovim plugin to trigger the [pre-commit](https://pre-commit.com) framework for 
various code linters and formatters within the in-built terminal. This plugin
is only designed to work within a git repository with a `pre-commit-config.yaml`
file as per the pre-commit setup.


### Installation

- With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'ttibsi/pre-commit.nvim',
```

- With [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ttibsi/pre-commit.nvim'

" Somewhere after plug#end()
lua require('Comment').setup()
```

