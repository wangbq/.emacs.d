;; This is where your customizations should live

;; Use command as control
(setq mac-command-modifier 'control)
(setq default-directory "~/")
;;(setq tab-width 4)
(setq-default tab-width 4)
(add-hook 'prog-mode-hook 'linum-mode)
(scroll-bar-mode t)

;; env PATH
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; Uncomment the lines below by removing semicolons and play with the
;; values in order to set the width (in characters wide) and height
;; (in lines high) Emacs will have whenever you start it

(setq initial-frame-alist '((top . 0) (left . 0) (width . 120) (height . 39)))


;; Place downloaded elisp files in this directory. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; set indent for c/c++
(setq-default c-basic-offset 4)

;; Themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'solarized-light t)

;; Uncomment this to increase font size
(set-face-attribute 'default nil :height 140)

;; Flyspell often slows down editing so it's turned off
;; (remove-hook 'text-mode-hook 'turn-on-flyspell)

;; Clojure
;; (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
;; (setq nrepl-history-file "~/.emacs.d/nrepl-history")
;; (setq nrepl-popup-stacktraces t)
;; (setq nrepl-popup-stacktraces-in-repl t)
;; (add-hook 'nrepl-connected-hook
;;           (defun pnh-clojure-mode-eldoc-hook ()
;;             (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
;;             (add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
;;             (nrepl-enable-on-existing-clojure-buffers)))
;; (add-hook 'nrepl-mode-hook 'subword-mode)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'nrepl-mode))
;; (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)

;; hippie expand - don't try to complete with file names
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name hippie-expand-try-functions-list))
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name-partially hippie-expand-try-functions-list))

(setq ido-use-filename-at-point nil)

;; Save here instead of littering current directory with emacs backup files
(setq backup-directory-alist `(("." . "~/.saves")))

(setq ring-bell-function 'ignore)

;; Auctex config
(load "auctex-pkg.el" nil t t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-source-correlate-method 'synctex)
(add-hook 'LaTeX-mode-hook
          (lambda()
            (add-to-list 'TeX-expand-list
                         '("%q" skim-make-url))))

(defun skim-make-url () (concat
                         (TeX-current-line)
                         " "
                         (expand-file-name (funcall file (TeX-output-extension) t)
                                           (file-name-directory (TeX-master-file)))
                         " "
                         (buffer-file-name)))

(setq TeX-view-program-list
      '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %q")))

(setq TeX-view-program-selection '((output-pdf "Skim")))

(load "cdlatex.el")
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)

(server-start)

;; octave mode
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; copy one line with C-c C-k
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
        (end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
          (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
        (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))
(global-set-key "\C-c\C-k" 'copy-line)

;; setup for org mode
(setq org-default-notes-file "~/work/org/notes.org")
(setq org-agenda-files  '("~/work/org/"))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(require 'root-help)
(setenv "ROOTSYS" "/Users/wangbq/src/root_v5.34.36.macosx64-10.11-clang70")
(setq root-executable (concat (getenv "ROOTSYS") "/bin/root"))
(setq root-executable-args "-l")

(defun yank-replace-rectangle (start end)
  "Similar like yank-rectangle, but deletes selected rectangle first."
   (interactive "r")
   (delete-rectangle start end)
   (pop-to-mark-command)
   (yank-rectangle))
 
(global-set-key (kbd "C-x r C-y") 'yank-replace-rectangle)
