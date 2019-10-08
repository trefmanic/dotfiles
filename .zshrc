#!/bin/zsh
## Установка zplug
## --------------------------------
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/zplug/zplug.git ~/.zplug
fi

## Инициализация zplug
## --------------------------------
source ~/.zplug/init.zsh

## Отслеживание скорости загрузки
# zmodload zsh/zprof

## Плагины oh-my-zsh
## --------------------------------
OMZ_PLUGINS=(ansible git ubuntu sudo tmux sublime command-not-found virtualenv)
for plugin in $OMZ_PLUGINS; do
    zplug "plugins/$plugin", from:oh-my-zsh
done

## Подключение плагина для истории,
## нормально работающего с fzf
## --------------------------------
zplug "trefmanic/oh-my-zsh", as:plugin, use:"plugins/history"

## Подключение fzf
## --------------------------------
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*linux*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2

## Переезжаем на Spaceship
## https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

## TODO: Внести новые настройки для Spaceship
#zplug "$HOME/.zsh_config", from:local, use:zshpower

## Пользовательские настройки, алиасы и функции
## --------------------------------
USER_SETTINGS=(functions aliases settings)
ZSH_CONFIG_DIR="$HOME/.zsh_config"
for setting in $USER_SETTINGS; do
    zplug "$ZSH_CONFIG_DIR", from:local, use:"$setting"
done

## Установка отсутствующих плагинов
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

## Загрузка zplug
zplug load
