#!/bin/bash

if [[ $dotfiles == "" ]]; then
  dotfiles=`pwd`
fi

ln -s ${dotfiles}/gitconfig ~/.gitconfig
ln -s ${dotfiles}/gitignore_global ~/.gitignore_global
ln -s ${dotfiles}/bashrc.mac.sh ~/.bashrc
ln -s ${dotfiles}/dockerrc.mac.sh ~/.dockerrc
ln -s ${dotfiles}/vimrc ~/.vimrc
ln -s ${dotfiles}/npmrc ~/.npmrc
ln -s ${dotfiles}/gemrc ~/.gemrc
