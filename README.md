## Tools

* [brew http://brew.sh/](http://brew.sh/)

  ```bash
  $ cat ./brew-list.txt | xargs -t -i {} brew install {}
  ```

## Languages - go

```bash
$ cd golib
$ go get -u github.com/golang/dep/cmd/dep
```

## Dotfiles

```bash
$ dotfiles=/Users/xiaoqin/workspace/dotfiles ./link.sh
$ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
$ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
```

## Archives

* [rvm(inactive) https://rvm.io/rvm/install](https://rvm.io/rvm/install)
* old apple gcc(inactive)

  ```bash
  $ brew tap homebrew/dupes
  $ brew install apple-gcc42
  $ export CC=/usr/local/bin/gcc-4.2
  ```
