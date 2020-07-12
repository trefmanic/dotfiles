;; ----------------------------------------
;;
;; ███████╗███╗   ███╗ █████╗  ██████╗███████╗
;; ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
;; █████╗  ██╔████╔██║███████║██║     ███████╗
;; ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
;; ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
;; ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝
;; ----------------------------------------

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
;;(xterm-mouse-mode 1)

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
(add-hook 'window-configuration-change-hook
          (lambda ()
            (set-window-margins (car (get-buffer-window-list (current-buffer) nil t)) 2 2)))


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
(global-set-key (kbd "C-c !") 'insert-shabang-python) ; Ctrl-x !

;; Вставка из буфера X11
;; Требуется установленный xsel
(defun x-paste ()
  "insert text on X11's clipboard to current buffer."
  (interactive)
  (insert-string (shell-command-to-string "xsel -b")))

;; Закрытие текущего буфера без запроса
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; Принудительное закрытие текущего буфера
(defun kill-this-buffer-volatile ()
    "Kill current buffer, even if it has been modified."
    (interactive)
    (set-buffer-modified-p nil)
    (kill-this-buffer))
(global-set-key (kbd "C-x d") 'kill-this-buffer-volatile)

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
(global-set-key (kbd "C-c q") 'calendar)
(global-set-key (kbd "<f5>") 'org-launch)

;; Прочие комбинации

(global-set-key (kbd "C-c y") 'x-paste)


;; Настройки для шифрования
(setq journal-ext ".gpg")
(require 'epa-file)
;; HACK!
(setq epa-file-encrypt-to '("trefmanic@gmail.com"))
(setq epa-file-select-keys 1)

;; Настройки для ведения дневника
(defgroup journal nil "Settings for the personal journal" :group
'applications)
(defcustom journal-dir "~/STORAGE/MEGA/LOG/" "Directory containing journal entries"
  :type 'string :group 'journal)
(defcustom journal-date-format "%x%n"
  "Format string for date, by default YYYY-MM-DD."
  :type 'string :group 'journal)
(defcustom journal-time-format "%n%R%n"
  "Format string for time, by default HH:MM. Set it to a blank string if you want to disable timestamps."
  :type 'string :group 'journal)
(defface journal '((t nil)) "Custom face to use in the journal" :group 'journal)

;(defvar journal-dir "~/STORAGE/MEGA/LOG/") ; Directory containing journal files
(defvar journal-date-list nil)
(defvar journal-file)
(defvar journal-ext)

;; Automatically switch to journal mode when opening a journal entry file
(add-to-list 'auto-mode-alist
                  (cons (concat (car (last (split-string journal-dir "/" t)))
                                   "/[0-9]\\{8\\}$") 'journal-mode))

(require 'calendar)
(add-hook 'calendar-initial-window-hook 'journal-get-list)
(add-hook 'calendar-today-visible-hook 'journal-mark-entries)
(add-hook 'calendar-today-invisible-hook 'journal-mark-entries)

;; Key bindings
(define-key calendar-mode-map "j" 'journal-read-entry)
(define-key calendar-mode-map "]" 'journal-next-entry)
(define-key calendar-mode-map "[" 'journal-previous-entry)
(global-set-key "\C-cj" 'journal-new-entry)

;; Journal mode definition
(define-derived-mode journal-mode text-mode "Journal" "Mode for writing or viewing entries written in the journal"
  (turn-on-visual-line-mode)
  (buffer-face-set 'journal)
  (add-hook 'change-major-mode-hook '(lambda nil (set-text-properties (point-min) (point-max) nil)) t t)
  (run-mode-hooks))

(add-hook 'journal-mode-hook 'journal-format-title)

(defun journal-format-title nil
  (save-excursion
    (let ((unsaved (buffer-modified-p)))
      (set-text-properties 1 (point-at-eol (goto-char (point-min)))
                                '(face (:height 1.5 :underline t)))
      (set-buffer-modified-p unsaved))))

;; Creates a new entry
(defun journal-new-entry nil "Open today's journal file and start a new entry"
  (interactive)
  (unless (file-exists-p journal-dir) (error "Journal directory %s not found" journal-dir))
  (find-file (concat (concat journal-dir (format-time-string "%Y%m%d")) journal-ext))
  (if view-mode (view-mode-disable))
  (setq buffer-read-only nil)
  (goto-char (point-max))
  (let ((unsaved (buffer-modified-p)))
    (if (equal (point-max) 1) (insert (format-time-string journal-date-format)))
    (unless (eq (current-column) 0) (insert "\n"))
    (remove-text-properties (point-min) (point-max) '(face))
    (let ((beg (point)))
      (insert (format-time-string journal-time-format))
      (put-text-property beg (max beg (- (point) 1)) 'face '(:weight bold)))
    (set-buffer-modified-p unsaved))
  (journal-format-title))

;;
;; Functions to browse existing journal entries using the calendar
;;

(defun journal-get-list nil "Loads the list of files in the journal directory, and converts it into a list of calendar DATE elements"
  (unless (file-exists-p journal-dir) (error "Journal directory %s not found" journal-dir))
  (setq journal-date-list
  (mapcar '(lambda (journal-file)
             (let ((y (string-to-number (substring journal-file 0 4)))
                       (m (string-to-number (substring journal-file 4 6)))
                                             (d (string-to-number (substring journal-file 6 8))))
                                                     (list m d y)))
                                                              (directory-files journal-dir nil (concat (concat "^[0-9]\\{8\\}" journal-ext) "$") nil)))
  (calendar-redraw))

(defun journal-mark-entries nil "Mark days in the calendar for which a diary entry is present"
  (dolist (journal-entry journal-date-list)
    (if (calendar-date-is-visible-p journal-entry)
      (calendar-mark-visible-date journal-entry))))

(defun journal-read-entry nil "Open journal entry for selected date for viewing"
  (interactive)
  (setq journal-file (int-to-string (+ (* 10000 (nth 2 (calendar-cursor-to-date))) (* 100 (nth 0 (calendar-cursor-to-date))) (nth 1 (calendar-cursor-to-date)))))
  (if (file-exists-p (concat (concat journal-dir journal-file) journal-ext))
      (view-file-other-window (concat ( concat journal-dir journal-file) journal-ext ) )
    (message "No journal entry for this date.")))

(defun journal-next-entry nil "Go to the next date with a journal entry"
  (interactive)
  (let ((dates journal-date-list))
    (while (and dates (not (calendar-date-compare (list (calendar-cursor-to-date)) dates)))
      (setq dates (cdr dates)))
    (if dates (calendar-goto-date (car dates)))))

(defun journal-previous-entry nil "Go to the previous date with a journal entry"
  (interactive)
  (let ((dates (reverse journal-date-list)))
    (while (and dates (not (calendar-date-compare dates (list (calendar-cursor-to-date)))))
      (setq dates (cdr dates)))
    (if dates (calendar-goto-date (car dates)))))

(provide 'journal)

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
