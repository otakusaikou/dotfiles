#!/bin/bash
# Vimのアプグレード & 必要なパッケージのインストール
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get --yes install software-properties-common
    sudo add-apt-repository --yes ppa:jonathonf/vim
    sudo apt update
    sudo apt-get install --yes vim vim-gnome vim-gtk python-flake8 pep8 pyflakes git cmake tmux zsh build-essential python2.7-dev curl
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

# Tmuxのステータスバー専用のスクリプトをダウンロード (macOSのみ対応)
# 詳しい説明はこちら -> https://goo.gl/8mGtk1
if [[ "$OSTYPE" == "darwin"* ]]; then
    # バッテリ残量を取得するスクリプト
    sudo wget -O /usr/local/bin/battery "https://github.com/b4b4r07/dotfiles/blob/master/.tmux/bin/battery?raw=true"
    sudo chmod 755 /usr/local/bin/battery

    # SSIDを取得するスクリプト
    sudo wget -O /usr/local/bin/wifi "https://github.com/b4b4r07/dotfiles/blob/master/.tmux/bin/wifi?raw=true"
    sudo chmod 755 /usr/local/bin/wifi
fi

# VimプラグインPowerline用のフォント
git clone https://github.com/powerline/fonts
./fonts/install.sh

# コーディング用のかっこいいフォント- FiraCode
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    mkdir -p ~/.local/share/fonts
    for type in Bold Light Medium Regular Retina; do wget -O ~/.local/share/fonts/FiraCode-$type.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$type.ttf?raw=true"; done
    sudo fc-cache -f
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap caskroom/fonts
    brew cask install font-fira-code
fi

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
# PowerlineとZshのテーマの適用にはターミナルの表示フォントをPowerline専用フォント(あるいはFiraCode)に変える必要があります
# また、メタキーを正しく動作させるにはメニューアクセスのショートカットキーを無効に(LINUX)、
# あるいはメタキーとしての機能を有効にしてください(macOS)
