(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)



;; *.~などのbackupファイルを作らない
(setq make-backup-files nil)
;; .#*などのbackupファイルを作らない
(setq auto-save-default nil)


;; ==============================
;; helm (MELPA)
;; ==============================
;; anythingの後継
(when (require 'helm-config nil t)
  (message "<<LOAD>> helm")
  (helm-mode 1)
  (define-key global-map (kbd "C-x c f") 'helm-find-files)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
)

;; ==============================
;; auto-complete (MELPA)
;; ==============================
 ;; 自動補完
(when (require 'auto-complete-config nil t)
  (message "<<LOAD>> auto-complete")
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs.d/config/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default)
)

;; ==============================
;; redo+ (MELPA)
;; ==============================
;; redo
(when (require 'redo+ nil t)
  (message "<<LOAD>> redo+")
  ;; C-.にredoを割り当てる
 (global-set-key (kbd "C-.") 'redo)
)

;; ==============================
;; sequential-command (MELPA)
;; ==============================
;; C-a C-a で先頭，C-e C-eで末尾に飛ぶ
(when (require 'sequential-command-config nil t)
  (message "<<LOAD>> sequential-command")
  (sequential-command-setup-keys)
)
