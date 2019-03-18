export ZSH="$HOME/.oh-my-zsh"
export SHELLTYPE="zsh"

plugins=(
  git
)

zhelp() {
  plugin=~/.oh-my-zsh/plugins/$1/$1.plugin.zsh
	if [[ $2 == "all" ]]; then
    cat $plugin
  else
    cat $plugin | grep alias
  fi
}

ZSH_THEME="robbyrussell" && source $ZSH/oh-my-zsh.sh

alias rl="clear;source $HOME/.zshrc"

for fn (.systemrc .dockerrc .workspacerc .shortcutrc)
do
  if [ -f $HOME/$fn ];then
    source $HOME/$fn
  fi
done

export PATH="$PATH:$WSPACE/dotfiles/golib/bin:$HOME/Downloads"

