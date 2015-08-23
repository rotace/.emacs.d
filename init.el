;; ***************************************************** ;;
;;       Emacs 設定ファイル
;;                           created by shibata
;; ***************************************************** ;;
;; おまじない
(require 'cl)
(message "<<Start>>...starting Emacs")

;; set variable
(setq gtags-suggested-key-mapping t)


;; ######################################################
;; Elispプログラミング補助関数
;; ######################################################
;; 参考: http://www.sodan.org/~knagano/emacs/dotemacs.html
;; 1.関数が存在するときだけ実行する．(car の fboundp を調べるだけ)
(defmacro exec-if-bound (sexplist)
  `(if (fboundp (car ',sexplist))
       ,sexplist))
;; 2.add-hook のエイリアス．引数を関数にパックしてhookに追加する
;; 使い方 add-hook で失敗する　->　defun-add-hook
(defmacro defun-add-hook (hookname &rest sexplist)
  `(add-hook ,hookname
	     (function (lambda () ,@sexplist))))
;; 3.安全なautoload
;; 使い方　autoload で失敗する　-> autoload-if-found
;;   "set autoload iff. FILE has found."
(defun autoload-if-found (function file &optional docstring interactive type)
  (and (locate-library file)
       (autoload function file docstring interactive type)))


;; ######################################################
;; 一般設定
;; ######################################################
;; 無効コマンドを有効化
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; 文字コード設定
(set-language-environment "Japanese")	;日本語
(prefer-coding-system 'utf-8)		;文字コード
;; Emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)
;; ediffコントロールパネルを別フレームにしない
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

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
;; (set-face-background 'region "darkgreen") ;リージョンの背景色を変更
;; ------------------------------------------------------
;;; 現在行のハイライト
(defface my-hl-line-face
  ;; 背景がdarkならば背景色を紺に
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景がlightならば背景色を緑に
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)
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
;; 起動時のサイズ，表示位置，フォントを指定
;; (setq initial-frame-alist
;;       (append (list
;; 	       '(width  . 90)
;; 	       '(height . 70)
;; 	       '(top  . 0)
;; 	       '(left . 1200)
;; 	       '(font . "VL Gothic-11")
;; 	       )
;; 	      initial-frame-alist))
(setq initial-frame-alist
      (append (list
	       '(width  . 90)
	       '(height . 48)
	       '(top  . 0)
	       '(left . 0)
	       '(font . "VL Gothic-10")
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
;; ------------------------------------------------------
;; バッファ名表示設定
(require 'uniquify)
;; filename<dir>
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ignore the buffer which is surround by *
(setq uniquify-ignore-buffers-re "*[^*]+*")
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
;; ウィンドウ最大化
(defun my-fullscreen ()
  (interactive)
  (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
    (cond
     ((null fullscreen)
     (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
    (t
     (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
  (redisplay))
(global-set-key [f11] 'my-fullscreen)	;[F11]: ショートカットキー
;; ------------------------------------------------------

;; ######################################################
;; バックアップ・オートセーブ・フック
;; ######################################################
;; バックアップファイルを作成しない
(setq make-backup-files nil) ; 初期値はt
;; オートセーブファイルを作らない
(setq auto-save-default nil) ; 初期値はt

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))

;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
;; (add-to-list 'backup-directory-alist
;;              (cons "." "~/.emacs.d/backups/"))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; オートセーブファイル作成までの秒間隔
;; (setq auto-save-timeout 15)
;; オートセーブファイル作成までのタイプ間隔
;; (setq auto-save-interval 60)
;; ------------------------------------------------------

;; ファイルが #! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode-hook用の関数を定義
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)
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
;; 起動・設定ファイル・ロードパス
;; ######################################################
;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
;; (add-to-load-path "elisp" "conf")
;; 環境変数の設定
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")


;; ######################################################
;;     Elisp 管理設定
;; ######################################################
;; ======================================================
;;  Emacs Lisp Package Archive（ELPA）
;; ======================================================
(when (require 'package nil t)
  (message "<<LOAD>> ELPA")
  ;; リポジトリ追加：Marmalade
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  ;; リポジトリ追加：開発者運営のELPA
  (add-to-list 'package-archives 
	       '("ELPA" . "http://tromey.com/elpa/"))
  ;; リポジトリ追加：MELPA
  (add-to-list 'package-archives 
	       '("MELPA" . "http://melpa.milkbox.net/packages/") t)
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))
;; 使い方1
;; M-x list-packages ... パッケージリスト一覧モード(iでチェック，xでインストール)
;; 使い方2
;; (package-install '**) ... パッケージインストールlisp

;; ======================================================
;; auto install (ELPA)
;; ======================================================
;; auto-installの設定
(when (require 'auto-install nil t)
  (message "<<LOAD>> auto-install")
  ;; インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  ;; (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))


;; ======================================================
;;  minor-mode-hack (ELPA)
;; ======================================================
;; マイナーモードキー衝突問題を解決する
(when (require 'minor-mode-hack nil t)
  (message "<<LOAD>> minor-mode-hack"))
;; Tips
;; マイナーモードの優先順位をエコーエリアに表示
;; M-x show-minor-mode-map-priority
;; マイナーモードの優先度を下げる
;; (lower-minor-mode-map-alist '**-mode)
;; マイナーモードの優先度をあげる
;; (raise-minor-mode-map-alist '**-mode)


;; ######################################################
;;     画面設定 elisp
;; ######################################################
;; ======================================================
;;  color-theme (ELPA)
;; ======================================================
;; 表示テーマの設定
;; ▽要拡張機能インストール(ELPA)
(when (require 'color-theme nil t)
  (message "<<LOAD>> color-theme")
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  ;; テーマ変更する
  (color-theme-clarity))

;; ######################################################
;;     Anything設定
;; ######################################################
;; ======================================================
;; Anything (ELPA)
;; ======================================================
(when (require 'anything nil t)
  (message "<<LOAD>> anything")
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; ======================================================
;; anything-config (ELPA)
;; ======================================================
;; 過去の履歴からペースト──anything-show-kill-ring
;; M-yにanything-show-kill-ringを割り当てる
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)


;; ######################################################
;;     入力支援 elisp
;; ######################################################
;; ======================================================
;; auto-complete
;; ======================================================
;; auto-complete設定
(when (require 'auto-complete-config nil t)
  (message "<<LOAD>> auto-complete")
  (add-to-list 'ac-dictionary-directories 
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; ======================================================
;; color-moccur (ELPA)
;; ======================================================
;; 検索結果をリストアップする──color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
  (message "<<LOAD>> color-moccur")
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; ======================================================
;; anything-c-moccur (ELPA)
;; ======================================================
;; moccurを利用する──anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (message "<<LOAD>> anything-c-moccur")
  (setq
   ;; anything-c-moccur用 `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-higligt-info-line-flag t
   ;; 現在選択中の候補の位置をほかのwindowに表示する
   anything-c-moccur-enable-auto-look-flag t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)
  ;; C-M-oにanything-c-moccur-occur-by-moccurを割り当てる
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))

;; ======================================================
;; wgrep (ELPA)
;; ======================================================
;; grepの結果を直接編集──wgrep
(when (require 'wgrep nil t)
  (message "<<LOAD>> wgrep"))

;; ======================================================
;; moccur-edit (auto-install)
;; ======================================================
;; moccurの結果を直接編集──moccur-edit
;; ▽要拡張機能インストール(auto-install)
;; (auto-install-from-emacswiki "moccur-edit.el")
;; moccur-editの設定
;; (when (require 'moccur-edit nil t)
;;   (message "<<LOAD>> moccur-edit")
;;   ;; moccur-edit-finish-editと同時にファイルを保存する
;;   (defadvice moccur-edit-change-file
;;     (after save-after-moccur-edit-buffer activate)
;;     (save-buffer)))

;; ======================================================
;; redo+ (ELPA)
;; ======================================================
(when (require 'redo+ nil t)
  (message "<<LOAD>> redo+")
  ;; C-' にリドゥを割り当てる
  ;; (global-set-key (kbd "C-'") 'redo)
  ;; 日本語キーボードの場合C-. などがよいかも
  (global-set-key (kbd "C-.") 'redo)
  )

;; ======================================================
;; undohist (ELPA)
;; ======================================================
;; 編集履歴を記憶する──undohist
(when (require 'undohist nil t)
  (message "<<LOAD>> undohist")
  (undohist-initialize))

;; ======================================================
;; sequential-command (ELPA)
;; ======================================================
;; ;; C-a C-a で先頭，C-e C-e で末尾に飛ぶ
(when (require 'sequential-command-config nil t)
  (message "<<LOAD>> sequential-command")
  (sequential-command-setup-keys))

;; ======================================================
;; autoinsert (default)
;; ======================================================
;; テンプレート自動入力
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/insert/")
(define-auto-insert "\\.sh$" "shellscript-template.sh")
(define-auto-insert "\\.c" (lambda () (insert "doxtempc")(yas/expand)))
(define-auto-insert "\\.h" (lambda () (insert "doxtemph")(yas/expand)))
(define-auto-insert "\\.cc" (lambda () (insert "doxtestc")(yas/expand)))
(define-auto-insert "\\.cpp" (lambda () (insert "doxtempc")(yas/expand)))
(define-auto-insert "\\.hpp" (lambda () (insert "doxtemph")(yas/expand)))

;; ======================================================
;; yasnippet (ELPA)
;; ======================================================
;; 略語展開(スニペット展開)
(when(require 'yasnippet nil t)
  (message "<<LOAD>> yasnippet")
  (setq yas-snippet-dirs
  	(cons "~/.emacs.d/snippets" yas-snippet-dirs)) ;作成するスニペットを格納
  (yas-global-mode 1)
  ;; 単語展開キーバインド
  (custom-set-variables '(yas-trigger-key "TAB"))
  ;; 既存スニペットを挿入する
  (define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
  ;; 新規スニペットを作成するバッファを用意する
  (define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
  ;; 既存スニペットを閲覧・編集する
  (define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file))



;; ######################################################
;;     開発支援ツール elisp
;; ######################################################
;; ======================================================
;; anything-gtags, anything-exuberant-ctags (ELPA)
;; ======================================================
;; Anythingとタグの連携
;; AnythingからTAGSを利用しやすくするコマンド作成
(when (and (require 'anything-gtags nil t)
	   (message "<<LOAD>> anything-gtags")
	   ;; (require 'anything-exuberant-ctags nil t)
	   )
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
        (list anything-c-source-imenu
              anything-c-source-gtags-select
              ;; etagsを利用する場合はコメントを外す
              anything-c-source-etags-select
              ;; anything-c-source-exuberant-ctags-select
              ))
  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
    "Preconfigured `anything' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
              (thing-at-point 'symbol)
              nil nil nil "*anything for tags*"))
  ;; M-tにanything-for-currentを割り当て
  (define-key global-map (kbd "M-t") 'anything-for-tags))

;; ======================================================
;; fold-dwim (ELPA)
;; ======================================================
;; 文章を折りたたむ fold-dwim
(when (require 'hideshow nil t)
  (message "<<LOAD>> hideshow"))
(when (require 'fold-dwim nil t)
  (message "<<LOAD>> fold-dwim")
  ;; 'hs-minor-mode　起動
  (add-hook 'c++-mode-hook 'hs-minor-mode)
  (add-hook 'fortran-mode-hook 'hs-minor-Mode)
  (global-set-key (kbd "<f7>")     'fold-dwim-toggle)
  (global-set-key (kbd "<S-f7>")   'fold-dwim-hide-all)
  (global-set-key (kbd "<S-M-f7>") 'fold-dwim-show-all))

;; ======================================================
;; flymake (default)
;; ======================================================
;; M-x flymake-mode でflymake起動
(when (require 'flymake)
  (message "<<LOAD>> flymake")
  ;; error無視設定
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  ;; .hpp をflymakeの対象に追加する
  (push '("\\.hpp\\'" flymake-master-make-header-init flymake-master-cleanup)
	flymake-allowed-file-name-masks)
  ;; ;; .cpp 用flymake設定(単独プログラムのみ有効)
  ;; (defun flymake-cpp-init ()
  ;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
  ;; 		       'flymake-create-temp-inplace))
  ;; 	   (local-file (file-relative-name
  ;; 			temp-file
  ;; 			(file-name-directory buffer-file-name))))
  ;;     (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
  ;; (push '("\\.cpp$" flymake-cpp-init) flymake-allowed-file-name-masks)
  )





;; ######################################################
;;     その他ユーティリティ
;; ######################################################
;; ======================================================
;; multi-term (ELPA)
;; ======================================================
;; ターミナルの利用 multi-term
;; multi-termの設定
;; (when (require 'multi-term nil t)
;;   (message "<<LOAD>> multi-term")
;;   ;; 使用するシェルを指定
;;   (setq multi-term-program "/bin/bash"))





;; ######################################################
;; キーバインド設定
;; ######################################################
;; C-hをバックスペースにする
;; 入力されるキーシーケンスを置き換える
;; ?\C-?はDELのキーシケンス
(keyboard-translate ?\C-h ?\C-?)
;; emacsclient用に、フックでkeyboard-translate起動
(add-hook 'after-make-frame-functions
	  (lambda (f) (with-selected-frame f
			(keyboard-translate ?\C-h ?\C-?))))

;; C-mにnewline-and-indentを割り当てる。
(global-set-key (kbd "C-m") 'newline-and-indent)
;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
;; (define-key global-map (kbd "C-t") 'other-window)
;; M-k でカレントバッファを閉じる
(define-key global-map (kbd "M-k") 'kill-this-buffer)
;; C-c cでcompileコマンドを呼び出す
(define-key mode-specific-map "c" 'compile)
;; C-c C-zでshellコマンドを呼び出す
;; (define-key mode-specific-map "\C-z" 'ansi-term)
;; zenkaku-hankaku で日本語入力に切り替える
;; (define-key global-map [zenkaku-hankaku] 'toggle-input-method)



;; ######################################################
;;     環境依存のあるElisp (バージョン依存)
;; ######################################################

;; ユーザー初期設定ファイルの指定
(setq user-init-file
      (concat "~/.emacs.d/emacs"(number-to-string emacs-major-version)
	      "-init.el"))
(if (file-exists-p (expand-file-name user-init-file))
    (load-file (expand-file-name user-init-file)))
;; ;; カスタム設定ファイルの指定
;; (setq user-init-file
;;       (concat "~/.emacs.d/emacs"(number-to-string emacs-major-version)
;; 	      "-custom.el"))
;; (if (file-exists-p (expand-file-name custom-file))
;;     (load-file (expand-file-name custom-file)))

     
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
;; ▽要拡張機能インストール(yum)
;; yum -y install gnuplot emacs-gnuplot
;; ※emacs-gnuplotも同時にインストールしないと、gnuplot.elがインストールされないので注意
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
;; ▽要拡張機能インストール(yum)
;; yum -y install --enablerepo=epel install octave
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

;; ======================================================
;; Yatex
;; ======================================================
;; ▽要拡張機能インストール(wget)
;; http://www.yatex.org/yatex1.77.tar.gz
(when (require 'yatex nil t)
  (message "<<LOAD>> yatex")
  (setq auto-mode-alist
	(cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
  (autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

  ;; 文章作成時の漢字コードの設定
  ;; 1 = Shift_JIS, 2 = ISO-2022-JP, 3 = EUC-JP, 4 = UTF-8
  ;; コードを指定してしまうと，別のコードのファイルも勝手に
  ;; ここで指定したコードに変換されてしまいトラブルのもとに
  ;; なるので，nilにしておくのが吉。
  (setq YaTeX-kanji-code nil)

					;LaTeXコマンドの設定
  (setq tex-command "platex")
					;YaTeXでのプレビューアコマンドを設定する
  (setq dvi2-command "pxdvi")
					;AMS-LaTeX を使用するかどうか
  (setq YaTeX-use-AMS-LaTeX t)
					;C-c t lにdvipdfmxを設定
  (setq dviprint-command-format "dvipdfmx %s")
					;bibtex に pbibtex
  (setq bibtex-command "pbibtex")

					; RefTeXをYaTeXで使えるようにする
  ;; (add-hook 'yatex-mode-hook '(lambda () (reftex-mode t)))
					; RefTeXで使うbibファイルの位置を指定する
					;(setq reftex-default-bibliography '("~/Library/TeX/bib/papers.bib"))

  ;;RefTeXに関する設定
  ;; (setq reftex-enable-partial-scans t)
  ;; (setq reftex-save-parse-info t)
  ;; (setq reftex-use-multiple-selection-buffers t)

  ;;RefTeXにおいて数式の引用を\eqrefにする
  ;; (setq reftex-label-alist '((nil ?e nil "=\\eqref{%s}" nil nil)))

					; [prefix] 英字 コマンドを[prefix] C-英字 に変更する
  ;; (setq YaTeX-inihibit-prefix-letter t)

					; 自動改行を抑制する
  ;; (add-hook 'yatex-mode-hook'(lambda ()(setq auto-fill-function nill)))
  )

;; ======================================================
;; aspell
;; ======================================================
;; ▽要拡張機能インストール(yum)
;; yum -y install --enablerepo=epel aspell-en aspell
;; run with Japanese
(when (require 'ispell nil t)
  (message "<<LOAD>> ispell")
  (setq-default ispell-program-name "aspell")
  (eval-after-load "ispell"
    '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
  ;; ;; run on specific mode
  ;; (add-hook 'yatex-mode-hook
  ;; 	  '(lambda () (flyspell-mode)))
  (global-set-key (kbd "<f8>") 'flyspell-mode))
;; Tips
;; M-x ispell-*
;; M-x flyspell-*

;; ======================================================
;; mozc
;; ======================================================
;; ▽要拡張機能インストール(yum)
;; yum -y install --enablerepo=rotacepkgs emacs-mozc
(when (require 'mozc nil t)
  (message "<<LOAD>> mozc")
  (setq default-input-method "japanese-mozc"))



