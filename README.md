#### Tools

* [brew http://brew.sh/](http://brew.sh/)
* [rvm(inactive) https://rvm.io/rvm/install](https://rvm.io/rvm/install)
* old apple gcc(inactive)

  ```bash
  $ brew tap homebrew/dupes
  $ brew install apple-gcc42
  $ export CC=/usr/local/bin/gcc-4.2
  ```

#### Dotfiles

```bash
$ dotfiles=/Users/xiaoqin/workspace/dotfiles ./link.sh
$ cd vscode # link to ~/Library/Application Support/Code/User
$ defaults write com.sublimetext.3 ApplePressAndHoldEnabled -bool false
$ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
$ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
```
