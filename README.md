# Overview

This repo has dotfiles for things like neovim, vim and bash.

**stow** is used to manage symlinks for installation, which requires a very specific folder structure.

# Installation/Uninstallation

Clone this repo to your home directory, then use **stow** to automatically create symlinks in the correct position.

To install all packages, run:
```bash
stow */
```

To install only the `nvim` package, run:
```bash
stow nvim/
```

To show which links would be created, without creating any links, run:
```bash
stow --no --verbose */
```

To remove all symlinks, run:
```bash
stow --delete */
```
