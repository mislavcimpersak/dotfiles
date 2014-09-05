#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# based on https://github.com/michaeljsmalley/dotfiles
############################

########## Variables

dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles_old             # old dotfiles backup directory
files="bashrc zshrc aliases profile oh-my-zsh"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# on ubuntu we need to install powerline fonts
install_powerline_fonts () {
    # check if PowerLine fonts are already installed
    if [ ! -f ~/.fonts/PowerlineSymbols.otf ]; then
        # Install Powerline using the following command:
        sudo pip install --user git+git://github.com/Lokaltog/powerline
        # Download the latest version of the symbol font and fontconfig file:
        wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
        wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
        # Move the symbol font to a valid X font path. Valid font paths can be listed with xset q:
        # create dir
        mkdir -p ~/.fonts/
        mv PowerlineSymbols.otf ~/.fonts/
        # Update font cache for the path you moved the font to
        sudo fc-cache -vf ~/.fonts/
        # Install the fontconfig file
        mkdir -p ~/.config/fontconfig/conf.d/
        mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
        # message
        echo "Powerline fonts installed and patched."
    fi
}

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
        install_powerline_fonts
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh

# install pip
install_pip() {
    # try installing pip
    if [[ command -v pip > /dev/null ]]; then        
        platform=$(uname);
        if [[ $platform == 'Linux' ]]; then
            sudo apt-get install python-pip
        elif [[ $platform == 'Darwin' ]]; then
            sudo easy_install pip
        fi
    else
        echo "pip already installed"
    fi
}

# install virutalenv and virutalenvwrapper
install_ve() {
    sudo pip install virutalenv
    sudo pip install virutalenvwrapper
}

install_pip
install_ve

set_osx_defaults() {
    platform=$(uname);
    if [[ $platform == 'Darwin' ]]; then
        # Always open everything in Finder's list view.
        defaults write com.apple.Finder FXPreferredViewStyle Nlsv
        
        # Show the ~/Library folder
        chflags nohidden ~/Library

        # Enable spring loading for all Dock items
        # defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

        # Show indicator lights for open applications in the Dock
        # defaults write com.apple.dock show-process-indicators -bool true
    fi
}

set_osx_defaults
