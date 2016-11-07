#!/bin/bash
# Install required tools
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Install the latest vim
    sudo add-apt-repository ppa:jonathonf/vim
    sudo apt update
    sudo apt install vim
    sudo apt-get install vim vim-gnome vim-gtk python-flake8 pep8 pyflakes git cmake tmux zsh build-essential python2.7-dev
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install vim flake8 git cmake tmux zsh reattach-to-user-namespace
fi

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
mkdir ~/.vim
mkdir ~/.vim/bundle

git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
vim +NeoBundleInstall +qall
cp vimrc/snippets/*.snippets ~/.vim/bundle/vim-snippets/snippets

# For YCM
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
cd -

# Remove unused directories
sudo rm -r vimrc fonts

# Finally you should open terminal and apply appropiate font styles that were installed previously
