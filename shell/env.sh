# Shared environment, sourced by zsh.

# [sysconfig]
ulimit -n 10000 2>/dev/null
# 不在 tar 包中产生 macOS 的 ._ 元文件
export COPYFILE_DISABLE=true

# [term]
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim

# [workspace]
export WSPACE="$HOME/workspace"

# [PATH]
export PATH="$PATH:$HOME/.local/bin:$HOME/Downloads"

# [nvm] Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# [machine-local secrets] (never committed)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
