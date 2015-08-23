# emacs lisp (master)
branch:masterは空のinit.elのみ  
emacsのバージョンに合わせてbranchをfetchすること。  
  
例：emacs24.3の場合  
    $ cd ~
    $ git clone http://github.com/rotace/.emacs.d.git  .emacs.d
    $ cd .emacs.d
    $ git branch -a				# branchを確認
    $ git checkout -b ver24.3 origin/ver24.3
