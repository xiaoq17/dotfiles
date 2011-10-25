# [docker]
# require docker for mac
docker-cleanup() {
  docker rmi $(docker images -q --filter='dangling=true')
  # this will remove db data volumns, be careful
  if [ "-d" == "$1" ]; then
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
  fi
}

docker-enter() {
  if [[ "" == "$1" ]]; then
    echo "docker-enter id|name [cmd]"
    echo "e.g. docker-enter mysql0"
    return
  fi
  cmd=$2
  if [[ "" == "$cmd" ]]; then
    cmd="bash"
  fi
  name=`echo $1| sed 's/^\///'`
  docker exec -it $name $cmd
}

alias dtools='docker run -it --rm=true index.qiniu.com/qiniutools bash'
