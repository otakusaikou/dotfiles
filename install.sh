#!/bin/bash
# Vimのアプグレード & 必要なパッケージのインストール
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo add-apt-repository ppa:jonathonf/vim
    sudo apt update
    sudo apt-get install vim vim-gnome vim-gtk python-flake8 pep8 pyflakes git cmake tmux zsh build-essential python2.7-dev curl
    sudo pip install pyopenssl -U
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install vim flake8 git cmake tmux zsh reattach-to-user-namespace
    pip install pyopenssl -U
fi

# プラグインマネージャdeinのインストール先
DEIN_HOME=~/.vim/dein

# TmuxとZshの設定ファイルをホームディレクトリにコピー
chsh -s /bin/zsh
cp ./tmux/.tmux.conf ~
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp ./tmux/.tmux-osx.conf ~
fi
cp ./zsh/.zshrc ~

# VimプラグインPowerline用のフォント
git clone https://github.com/powerline/fonts
sudo ./fonts/install.sh

# Vim設定ファイルをコピー
touch ~/.viminfo
cp ./vim/UNIX/.vimrc ~

# Vimプラグインのインストール
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $DEIN_HOME
vim "+call dein#install()"
cp ./vim/snippets/*.snippets $DEIN_HOME/repos/github.com/honza/vim-snippets/snippets

# VimプラグインYouCompleteMeのインストール
cd $DEIN_HOME/repos/github.com/Valloric/YouCompleteMe
./install.py --clang-completer
vim "+call dein#update()"
cd -

# 不要ファイルを削除
sudo rm -r fonts installer.sh

# P.S.
# PowerlineとZshのテーマの適用にはターミナルの表示フォントをPowerline専用フォントに変える必要があります
# また、メタキーを正しく動作させるにはメニューアクセスのショートカットキーを無効に(LINUX)、
# あるいはメタキーとしての機能を有効にしてください(macOS)
