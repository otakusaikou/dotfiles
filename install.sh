#!/bin/bash
# Install required tools
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Install the latest vim
    sudo add-apt-repository ppa:jonathonf/vim
    sudo apt update
    sudo apt install vim
    sudo apt-get install vim vim-gnome vim-gtk python-flake8 pep8 pyflakes git cmake tmux zsh build-essential python2.7-dev curl
    sudo pip install pyopenssl -U
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install vim flake8 git cmake tmux zsh reattach-to-user-namespace
    pip install pyopenssl -U
fi

# Define the installation directory for dein plugin manager
DEIN_HOME=~/.vim/dein

# For tmux and zsh
chsh -s /bin/zsh
cp .tmux.conf ~
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp .tmux-osx.conf ~
fi
cp .zshrc ~

# Install fonts for powerline plugin
git clone https://github.com/powerline/fonts
sudo ./fonts/install.sh

# Vim configuration file
touch ~/.viminfo
git clone http://github.com/otakusaikou/vimrc
cp vimrc/UNIX/.vimrc ~

# For vim plugins
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $DEIN_HOME
vim "+call dein#install()"
cp vimrc/snippets/*.snippets $DEIN_HOME/repos/github.com/honza/vim-snippets/snippets

# For YCM
cd $DEIN_HOME/repos/github.com/Valloric/YouCompleteMe
./install.py --clang-completer
vim "+call dein#update()"
cd -

# Remove unused files
sudo rm -r vimrc fonts installer.sh

# Finally you should open terminal and apply appropiate font styles that were installed previously
