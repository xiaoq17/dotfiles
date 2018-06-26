## Tools

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

  ```
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  ```

* [brew http://brew.sh/](http://brew.sh/)

  ```
  $ cat ./brew-list.txt | xargs -t -I {} brew install {}
  ```

## Languages - go

```
$ cd golib
$ go get -u github.com/golang/dep/cmd/dep
$ go get -u github.com/alecthomas/gometalinter
$ gometalinter --install &> /dev/null
```

## Dotfiles

```
$ dotfiles=/Users/xiaoqin/workspace/dotfiles ./link.sh
$ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
$ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
```
