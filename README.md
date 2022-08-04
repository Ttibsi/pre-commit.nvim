# pre-commit.nvim
This Neovim plugin triggers the [pre-commit](https://pre-commit.com/) 
framework for various code linters and formatters. It's designed to only work
within a git repository that already has a `.pre-commit-config.yaml` file. 
Please see the pre-commit documentation for configuration.


### Installation

- With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'ttibsi/pre-commit.nvim',
```

- With [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ttibsi/pre-commit.nvim'
```

### To use
Run `:Precommit` in the nvim command mode and it'll trigger. 
