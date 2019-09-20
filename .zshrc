export ZSH="/home/trefmanic/.oh-my-zsh"

# Включение темы powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    ansible
    sublime
    ubuntu
    sudo
    tmux
    command-not-found
    git
    virtualenv
    history
    pass
)

# Подключение oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Путь к настройкам пользователя
export USER_CONF="/home/trefmanic/.zsh_config"

# Подключение настроек пользователя
if [ -f $USER_CONF/settings ]; then
    source $USER_CONF/settings
else
    print "$ZSHCONF/settings not found"
fi

# Подключение алиасов
if [ -f $USER_CONF/aliases ]; then
    source $USER_CONF/aliases
else
    print "$USER_CONF/aliases not found"
fi

# Подключение функций
if [ -f $USER_CONF/functions ]; then
    source $USER_CONF/functions
else
    print "$USER_CONF/functions not found"
fi

# Подключение конфигурации powerlevel10k
if [ -f $USER_CONF/zshpower ]; then
    source $USER_CONF/zshpower
else
    print "$USER_CONF/zshpower not found"
fi

# Подключение fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt append_history share_history histignorealldups
