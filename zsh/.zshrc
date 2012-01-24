# Set up the prompt

umask 022

source $ZDOTDIR/.zaliases
source $ZDOTDIR/.zcompsys
source $ZDOTDIR/.zprompt
source $ZDOTDIR/.zplugins

# Enable Incremental completion
#source $ZDOTDIR/plugin/incr*.zsh
#autoload predict-on
#predict-on

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# cdの履歴を表示
setopt auto_pushd
# 同ディレクトリを履歴に追加しない
setopt pushd_ignore_dups
# ディレクトリ名だけで、ディレクトリの移動をする
setopt auto_cd
# ビープ音を鳴らさないようにする
setopt no_beep

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_ignore_space     # 先頭がスペースの場合、ヒストリに追加しない
setopt extended_history      # コマンドの開始時刻と経過時間を登録

setopt extended_glob         # 
# dabbrev
HARDCOPYFILE=$HOME/.tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
        local reply lines=80 # 80行分
        screen -X eval "hardcopy -h $HARDCOPYFILE"
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

# ターミナルのタイトル
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# カーソル位置から前方削除(Ctrl-u)
bindkey '^U' backward-kill-line

# Ctrl-h で単語ごとに削除
bindkey "^h" backward-kill-word
# / を単語の一部とみなさない記号の環境変数から削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

REPORTTIME=1 #実行3秒以上掛かった時時間を表示
# time の書式を設定
TIMEFMT="\
The name of this job.             :%J
CPU seconds spent in user mode.   :%U
CPU seconds spent in kernel mode. :%S
Elapsed time in seconds.          :%E
The  CPU percentage.              :%P"

## lsとpsの設定
### ls: できるだけGNU lsを使う。
### ps: 自分関連のプロセスのみ表示。
case $(uname) in
    *BSD|Darwin)
	if [ -x "$(which gnuls)" ]; then
	    alias ls="gnuls"
	    alias la="ls -lhAF --color=auto"
	else
	    alias la="ls -lhAFG"
	fi
	alias ps="ps -fU$(whoami)"
	;;
    SunOS)
	if [ -x "`which gls`" ]; then
	    alias ls="gls"
	    alias la="ls -lhAF --color=auto"
	else
	    alias la="ls -lhAF"
	fi
	alias ps="ps -fl -u$(/usr/xpg4/bin/id -un)"
	;;
    *)
	alias la="ls -lhAF --color=auto"
	alias ps="ps -fU$(whoami) --forest"
	;;
esac
