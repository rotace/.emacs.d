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
  (define-key global-map (kbd "C-x b") 'helm-buffers-list)
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






 
;; ######################################################
;; 画面設定
;; ######################################################
;; ------------------------------------------------------
;; 時計を表示（好みに応じてフォーマットを変更可能）
;; (setq display-time-day-and-date t) ; 曜日・月・日を表示
;; (setq display-time-24hr-format t) ; 24時表示
;; (display-time-mode t)
;; ------------------------------------------------------
(setq frame-title-format "%f") ; タイトルバーにファイルのフルパスを表示
(global-linum-mode t)	       ; 行番号を常に表示
(column-number-mode t)	       ;カラム番号も表示
(size-indication-mode t)       ;ファイルサイズを表示
;; ------------------------------------------------------
;; 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0)	       ; 表示までの秒数。初期値は0.125
(show-paren-mode t)		       ; 有効化
(setq show-paren-style 'parenthesis)   ;parenのスタイル
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")
;; ------------------------------------------------------
;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;; これだとエコーエリアがチラつく
      ;;(count-lines-region (region-beginning) (region-end))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))
;; ------------------------------------------------------



;; ######################################################
;; テキスト編集
;; ######################################################
;; cua-modeの設定
(cua-mode t) ; cua-modeをオン
(setq cua-enable-cua-keys nil) ; CUAキーバインドを無効にする
;; ------------------------------------------------------
;;; カーソル位置のファイルパスやアドレスを "C-x C-f" で開く
(ffap-bindings)
;; ------------------------------------------------------
;; TODOなどをハイライトする(c,c++,fortran)
(defun highlight-flag ()
  (font-lock-add-keywords nil
	     '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t))))
(add-hook 'f90-mode-hook 'highlight-flag)
(add-hook 'c-mode-common-hook 'highlight-flag)
;; ------------------------------------------------------
;;; 改行やタブを可視化する whitespace-mode
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□]) ; zenkaku space
        (newline-mark 10 [8629 10]) ; newlne
        (tab-mark 9 [187 9] [92 9]) ; tab » 187
        )
      whitespace-style
      '(spaces
        ;; tabs
        trailing
        newline
        space-mark
        tab-mark
        newline-mark))
;; whitespace-modeで全角スペース文字を可視化　
;; (setq whitespace-space-regexp "\\(\x3000+\\)")
;; F6 で whitespace-mode をトグル
(define-key global-map (kbd "<f6>") 'global-whitespace-mode)
;; ------------------------------------------------------



;; ######################################################
;;     環境依存のあるElisp (外部ツール依存) 
;; ######################################################
;; ホスト環境に依存するので、システム側にインストールすること！
;; インストール先の例
;; /usr/share/emacs/2*.*/site-lisp
;; /usr/share/emacs/site-lisp
;; /usr/local/share/emacs/2*.*/site-lisp
;; /usr/local/share/emacs/site-lisp

;; ======================================================
;; gnuplot
;; ======================================================
;; ▽要拡張機能インストール(apt-get)
;; sudo apt-get -y install gnuplot gnuplot-mode
;; ※gnuplot-modeも同時にインストールしないと、gnuplot.elがインストールされないので注意
;; these lines enable the use of gnuplot mode
(when (require 'gnuplot nil t)
  (message "<<LOAD>> gnuplot-mode")
  (autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

  ;; this line automatically causes all files with the .gp extension to
  ;; be loaded into gnuplot mode
  (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

  ;; This line binds the function-9 key so that it opens a buffer into
  ;; gnuplot mode 
  (global-set-key [(f9)] 'gnuplot-make-buffer))


;; ======================================================
;; cmake
;; ======================================================
(when (require 'cmake-mode nil t) ; Add cmake listfile names to the mode list.
  (message "<<LOAD>> cmake-mode")
  (setq auto-mode-alist
	(append
	 '(("CMakeLists\\.txt\\'" . cmake-mode))
	 '(("\\.cmake\\'" . cmake-mode))
	 auto-mode-alist)))

;; ======================================================
;; gtags
;; ======================================================
;; ▽要拡張機能インストール(wgt)
;; http://tamacom.com/global/global-6.1.tar.gz
(progn
  ;; gtags キーバインド有効化
  ;; ※この位置だと変数定義前にgtagsの読み込みが行われるらしいので、
  ;; init.elの頭に変数定義のセクションを設けた
  (setq gtags-suggested-key-mapping t)
  ;; gtagsインストール(gtags-mode...マイナーモード)
  (when (require 'gtags nil t)
    (message "<<LOAD>> gtags")
    ;; c,c++を読み込んだ時に起動（フック）
    (add-hook 'c-mode-common-hook 'gtags-mode)
    (add-hook 'c++-mode-common-hook 'gtags-mode)
    ;; 読み込み専用モード
    ;; (setq view-read-only t)
    ;; (setq gtags-read-only t)
    ;; M-*で戻るとき、戻る前のバッファを削除
    (setq gtags-pop-delete t)
    ;; パスを相対表示にする
    (setq gtags-path-style 'relative)))

;; ======================================================
;; octave
;; ======================================================
;; ▽要拡張機能インストール(apt-get)
;; sudo apt-get -y install install octave
;; octave-mode
(when (require 'octave-mod nil t)
  (message "<<LOAD>> octave")
  (autoload 'octave-mode "octave-mod" nil t)
  (setq auto-mode-alist
	(cons '("\\.m$" . octave-mode) auto-mode-alist))
  (add-hook 'octave-mode-hook
	    (lambda()
	      (abbrev-mode 1)
	      (auto-fill-mode 1)
	      (if (eq window-system 'x)
		  (font-lock-mode 1)))))

