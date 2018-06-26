export WSPACE=$HOME'/workspace'
cw() {
  cd $WSPACE/$1
}

# require direnv
eval "$(direnv hook $SHELLTYPE)"
