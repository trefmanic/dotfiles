
### Установка

* Клонировать репозиторий:
```
git clone --bare https://github.com/trefmanic/dotfiles.git $HOME/.dotfiles
```

* Установить алиас в текущем шелле:
```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

* Получить файлы:
```
dotfiles checkout
```

[//]: # (Created README)
[//]: # (Enabled GPG signing)
