Dotfiles
========
Collection of my dotfiles + an install script.

The install script will:

1. Back up any existing dotfiles in home directory to `~/dotfiles_old/`
2. Create symlinks to the dotfiles in `~/dotfiles/` in home directory
3. Clone the `oh-my-zsh` repository from my GitHub (for use with `zsh`)
4. Check to see if `zsh` is installed, if it isn't, try to install it.
5. If zsh is installed, run a `chsh -s` to set it as the default shell.
6. Install pip.
7. Install virtualenv and virtualenvwrapper.


Installation
------------

``` bash
git clone git://github.com/mislavcimpersak/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```