# emacs lisp (for emacs27.1 on Debian Bullseye)
  
## パッケージのインストール
```bash
$ cd; git clone git@github.com:rotace/.emacs.d
$ git checkout ver27.1
$ sudo apt install emacs-nox
$ emacs .emacs.d/init.el
```
GPGkeyのエラーでELPAからパッケージをダウンロードできない場合は、以下を参照。
https://qiita.com/MeguruMokke/items/eb5cd6d49460d1c1e042

## 言語サーバのインストール
* [lsp-mode](https://emacs-lsp.github.io/lsp-mode/page/languages/)

### Rust
```bash
$ curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/bin/rust-analyzer
```

### Python
```bash
$ pip install python-lsp-server[all]
```

## キーバインド
### Rust
* [cargo](https://stable.melpa.org/#/cargo)

### python
* [elpy](https://elpy.readthedocs.io/en/latest/quickstart.html)
