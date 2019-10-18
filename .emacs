;; Главные настройки путей
;; не менять!

(setenv "PATH" (concat "/usr/local/bin:/opt/local/bin:/usr/bin:/bin:/home/abedra/.cabal/bin" (getenv "PATH")))
(require 'cl) 

;; Настройки локали
(set-language-environment "Russian")
(set-terminal-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Настройки пакетов

;; Для стабильных версий использовать
;; melpa-stable

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;;; Загрузка начальных пакетов
(defvar prelude-packages
  '( haskell-mode )
  "A list of packages to ensure are installed at launch.")

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (prelude-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")

  ;; install the missing packages
  (dolist (p prelude-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'prelude-packages)
;;; end load packages


;; Пакеты пользователя
(defvar trefmanic/packages '(ac-slime
                          auto-complete
                          autopair
                          haml-mode
                          markdown-mode
			  poly-markdown
			  poly-R
                          php-mode
			  rvm
			  zenburn-theme
			  2048-game
			  rust-mode
			  yaml-mode
			  ox-jekyll-md)

  "Default packages")

(defun trefmanic/packages-installed-p ()
  (cl-loop for pkg in trefmanic/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (cl-return t)))

(unless (trefmanic/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg trefmanic/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Поддержка мыши
(xterm-mouse-mode 1)

;; Отключение экрана первоначальной настройки
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

;; Отключение меню
(menu-bar-mode -1)

;; Настройки выделения (с перезаписью)
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Отображение пустых строк
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Табуляция пробелами
(setq tab-width 2
      indent-tabs-mode nil)

;; Отключение бэкапа
(setq make-backup-files nil)

;; Замена yes и no на "y" и "n"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Настройки внешнего вида
(load-theme 'zenburn t)

;; Перекраска фона zenburn
(with-eval-after-load "zenburn-theme"
  (zenburn-with-color-variables
    (custom-theme-set-faces
     'zenburn
     `(default ((t (:background ,"#444444")))))))

;; Отступ с левого края
(set-window-margins nil 2)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.html" . html-mode))

;; Настройки org-mode
(with-eval-after-load 'org
(setq org-default-notes-file (expand-file-name "notes.org"))
(setq org-log-done 'time))

;; Собственные функции

;; Вставить пояснение для интерпретатора Python
(defun insert-shabang-python ()                                                                              
                "Insert #!/usr/bin/python at point"                                                     
		(interactive)
		(insert "#!/usr/bin/python\n"))
(global-set-key (kbd "C-x !") 'insert-shabang-python) ; Ctrl-x !

;; Вставка из буфера X11
;; Требуется установленный xsel
(defun x-paste ()
  "insert text on X11's clipboard to current buffer."
  (interactive)
  (insert-string (shell-command-to-string "xsel -b")))

;; Запуск корневого документа org-mode
(defun org-launch()
(interactive)
(find-file "~/root.org")
)

;; Глобальные комбинации клавиш

;; Комбинации для org-mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c t") 'org-insert-todo-heading)
(global-set-key (kbd "<f5>") 'org-launch)

;; Прочие комбинации

(global-set-key (kbd "C-c y") 'x-paste)

;; TODO: Подумать, нужно ли это
(global-set-key (kbd "C-f") 'isearch-forward); Переопределяет Ctrl-f

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar man md odt)))
 '(package-selected-packages
   (quote
    (ox-jekyll-md yaml-mode rust-mode 2048-game zenburn-theme rvm php-mode poly-R poly-markdown markdown-mode haml-mode autopair ac-slime haskell-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
