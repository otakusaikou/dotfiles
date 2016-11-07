### 基本的な設定
# デフォルト自動補完機能を有効化
autoload -U compinit
compinit

# ディレクト名で目標場所に移動
setopt auto_cd

# ディレクトリの移動履歴の利用
setopt auto_pushd

# コマンドのスペルチェックを有効化
setopt correct

# カラー表示機能を有効化
autoload -Uz colors
colors

### プロンプト関係
# 特殊文字
ARROW=$'\ue0b0'
ARROW2=$'\ue0b1'
BRANCH=$'\ue0a0'
CHECK=$'\u2714'
CROSS=$'\u2718'
LIGHTNING=$'\u26a1'

autoload vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "$BRANCH %r $ARROW2 %b%u%c"
zstyle ":vcs_info:git:*" actionformats "$BRANCH %r $ARROW2 %b%u%c $ARROW2 %a"
zstyle ":vcs_info:git:*" unstagedstr " $ARROW2 Unstaged"
zstyle ":vcs_info:git:*" stagedstr " $ARROW2 Staged"

# プロンプト変数の中の変数参照を有効化
setopt prompt_subst

git_is_track_branch(){
    if [ "$(git remote 2>/dev/null)" != "" ]; then
        local target_tracking_branch="origin/$(git rev-parse --abbrev-ref HEAD)"
        for tracking_branch in $(git branch -ar) ; do
            if [ "$target_tracking_branch" = "$tracking_branch" ]; then
                echo "true"
            fi
        done
    fi
}

git_info_pull(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local head_rev="$(git rev-parse HEAD)"
        local origin_rev="$(git rev-parse origin/$current_branch)"
        if [ "$head_rev" != "$origin_rev" ] && [ "$(git_info_push)" = "" ]; then
                echo " $ARROW2 Can Be Pulled"
        fi
    fi
}

git_info_push(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local push_count=$(git rev-list origin/"$current_branch".."$current_branch" 2>/dev/null | wc -l | sed 's/  *//g')
        if [ "$push_count" -gt 0 ]; then
            echo " $ARROW2 Can Be Pushed($push_count)"
        fi
    fi
}

function update_git_info() {
    LANG=en_US.UTF-8 vcs_info
    _vcs_info=$vcs_info_msg_0_
    _git_info_push=$(git_info_push)
    _git_info_pull=$(git_info_pull)
    local BG_COLOR="069"
    local FG_COLOR="000"
    if [ -n "$_vcs_info" ]; then
        if [ -n "$_git_info_push" ] || [ -n "$_git_info_pull" ]; then
            BG_COLOR="220"
            FG_COLOR="000"
        fi

        if [[ -n `echo $_vcs_info | grep -Ei "merge|unstaged|staged" 2> /dev/null` ]]; then
            BG_COLOR="088"
            FG_COLOR="255"
        fi
        echo "%K{$BG_COLOR}%F{026}$ARROW%f%F{$FG_COLOR} $_vcs_info$_git_info_push$_git_info_pull %f%k%K{002}%F{$BG_COLOR}$ARROW%f%k"
    else
       echo "%K{002}%F{026}$ARROW%f%k"
    fi
}

PROMPT_HOST="%K{026}%{%F{000}%}[ %f%(?.%{%F{002}%}$CHECK.%{%F{088}%}$CROSS)%f %F{000}%n ] %f%k"
PROMPT_DIR="%K{002}%F{000} %~ %f%k%K{000}%F{002}$ARROW%k%f"
PROMPT_SU="%(!.%F{220}%f $LIGHTNING . )"
PROMPT_NL="%K{026} %F{000}$%f %k%K{000}%F{026}$ARROW%f%k"
PROMPT='
$PROMPT_HOST$(update_git_info)$PROMPT_DIR$PROMPT_SU
$PROMPT_NL '
SPROMPT='${WHITE}%r is correct? [n,y,a,e]: %{$reset_color%}'

### tmux関係
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X" && exit 0;
            else
                tmux new-session && echo "tmux created new session" && exit 0;
            fi
        fi
    fi
}
tmux_automatically_attach_session

# Aliases
if is_osx; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --colour=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Added by Anaconda2 4.2.0 installer
# export PATH="$HOME/anaconda2/bin:$PATH";
