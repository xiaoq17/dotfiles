# [term]
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim

function console_hints () {
  TIME_HINT='('`date +%H:%M:%S`')'
  IP_HINT=' ('`ifconfig | grep "inet " | grep -v 127.0.0. | awk '{ print $2 }'`')'
  LANG_HINT=""
  if which rvm >/dev/null; then
    RVM_HINT=`rvm current`
    LANG_HINT="$RVM_HINT;"$LANG_HINT
  fi
  if which go >/dev/null; then
    GO_HINT=`go version | awk '{print $3}'`
    LANG_HINT="$GO_HINT;"$LANG_HINT
  fi
  if [ -n "${VIRTUAL_ENV-}" ] ; then
    PY_HINT=`basename $VIRTUAL_ENV`
    PY_HINT=${PY_HINT//python/py}
    PY_HINT=${PY_HINT//-/}
    LANG_HINT="$PY_HINT-v;"$LANG_HINT
  else
    PY_HINT=`python -V 2>&1`
    PY_HINT=${PY_HINT//Python/py}
    PY_HINT=${PY_HINT// /}
    LANG_HINT="$PY_HINT;"$LANG_HINT
  fi
  GIT_HINT=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'`
  echo $TIME_HINT$IP_HINT$GIT_HINT' '`docker-env`' ('$LANG_HINT')'
}

docker-env() {
  if which docker > /dev/null; then
    if [[ "${DOCKER_ENV}" == "" ]]; then
      echo "(local)"
    else
      echo "(${DOCKER_ENV})"
    fi
  fi
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOUR="\[\033[0m\]"

PS1="$GREEN[\u@\h:\w]$YELLOW \$(console_hints) $NO_COLOUR\n[ \W ]\$ "

# [bash]
alias ..="cd .."
alias df="df -h"
alias du="du -h"
alias la='ls -alh'
alias ll='ls -lh'
alias cl='clear'
alias rl='cl;source ~/.bashrc;'
uxdate() {
  if [ "$1" == "" ]; then
    echo "uxdate \"2015-07-13 18:02:00\" [more dates...]"
  else
    for date in "$@"; do
      echo $date, `date -j -f "%Y-%m-%d %H:%M:%S" "$date" "+%s"`
    done
  fi
}

# [working dirs & projects]
export WSPACE=$HOME'/workspace'
alias lw='ls $WSPACE'
cw() {
  cd $WSPACE/$1
}

# [git]
# require git
alias gpr='git pull --rebase'
alias gst='git status -s'
alias gci='git commit'
alias gdf='git diff --color'
alias gdi='git di'
alias gco="git checkout"
alias glog="git log --pretty=format:'%Cred%h%Creset - %s %C(bold blue)<%an>%Creset %Cgreen(%cd)%Creset' --date=iso"
alias gbr='git branch -avv'
alias gbl='git branch -vv'
alias gbd='git branch -d'
gsync() {
  branch='develop'
  if [ $1 ]; then
    branch=$1
  fi
  echo "==> git stash"
  cur_branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  stashed=`git stash`
  echo $stashed
  echo "==> switch to branch=$branch, sync direction: upstream -> local -> origin"
  git checkout $branch
  git branch -vv | grep $branch
  git remote -v | grep -E "upstream|origin"
  echo "==> fetch from upstream && merge"
  git fetch upstream -p && git merge upstream/$branch
  echo "==> cleanup origin, push to origin"
  git fetch origin -p && git push origin
  echo "==> switch back branch=$cur_branch"
  git checkout $cur_branch
  if ! [[ $stashed == No* ]]; then
    echo "==> git stash pop"
    git stash pop
  fi
}
alias gsm='gsync master'
alias gsd='gsync dev'
gmlog() {
  git log --pretty=format:'%h %ae %s (%cd)' --date=iso $1^..$1
}
# switch acc
alias g17='cw dotfiles;gco master;cd -'
alias g08='cw dotfiles;gco 08;cd -'

# [tools]
# require Ghostscript
shrinkpdf() {
  gs -q -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.3 \
    -dPDFSETTINGS=/screen \
    -dEmbedAllFonts=true \
    -dSubsetFonts=true \
    -dColorImageDownsampleType=/Bicubic \
    -dColorImageResolution=72 \
    -dGrayImageDownsampleType=/Bicubic \
    -dGrayImageResolution=72 \
    -dMonoImageDownsampleType=/Bicubic \
    -dMonoImageResolution=72 \
    -sOutputFile=out.pdf \
    $1
}
# require python
alias pj='python -m json.tool'
# https://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true
# require docker
source ~/.dockerrc
# require direnv
eval "$(direnv hook bash)"


# [env]
if [ -f ~/.local_bashenv.sh ]; then
  . ~/.local_bashenv.sh
fi

# [sysconfig]
ulimit -n 10000

# [PATH]
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$WSPACE/golib/bin:$HOME/Downloads:$HOME/.rvm/bin"
