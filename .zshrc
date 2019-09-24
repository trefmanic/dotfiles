#!/bin/zsh
## Установка zplug
## --------------------------------
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/zplug/zplug.git ~/.zplug
fi

## Инициализация zplug
## --------------------------------
source ~/.zplug/init.zsh

## Плагины oh-my-zsh
## --------------------------------
zplug "plugins/ansible", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/ubuntu", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/sublime", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/pass", from:oh-my-zsh

## Подключение плагина для истории,
## нормально работающего с fzf
## --------------------------------
zplug "trefmanic/oh-my-zsh", as:plugin, use:"plugins/history"

## Подключение fzf
## --------------------------------
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*linux*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2

## Подключение темы powerlevel10k и её настройки
## --------------------------------
zplug "romkatv/powerlevel10k", use:"powerlevel10k.zsh-theme"
zplug "$HOME/.zsh_config", from:local, use:zshpower

## Пользовательские настройки, алиасы и функции
## --------------------------------
zplug "$HOME/.zsh_config", from:local, use:settings
zplug "$HOME/.zsh_config", from:local, use:aliases
zplug "$HOME/.zsh_config", from:local, use:functions


## Установка отсутствующих плагинов
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

## Загрузка zplug
zplug load
