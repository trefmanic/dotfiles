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
OMZ_PLUGINS="{plugins/ansible,plugins/git,plugins/ubuntu,plugins/sudo,\
plugins/tmux,plugins/sublime,plugins/command-not-found,\
plugins/virtualenv,plugins/pass}"
zplug $OMZ_PLUGINS, from:oh-my-zsh

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
ZSH_CONFIG="$HOME/.zsh_config"
zplug "$ZSH_CONFIG", from:local, use:"{settings,aliases,functions}"

## Установка отсутствующих плагинов
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

## Загрузка zplug
zplug load
