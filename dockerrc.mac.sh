# [docker]
# require docker for mac
docker-cleanup() {
  docker rmi -f $(docker images -q --filter='dangling=true')
  # this will remove db data volumns, be careful
  if [ "-d" == "$1" ]; then
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
  fi
}

mini-docker() {
  echo "=== change to minikube docker ENV ==="
  eval $(minikube docker-env)
  export DOCKER_ENV=minikube
}

local-docker() {
  echo "=== change to local docker ENV ==="
  unset DOCKER_TLS_VERIFY
  unset DOCKER_HOST
  unset DOCKER_CERT_PATH
  unset DOCKER_API_VERSION
  unset DOCKER_ENV
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

alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

# [k8s]
source <(kubectl completion bash)
kubessh() {
  if [ "$1" == "" ]; then
    echo "Usage: kubessh <pod>"
    exit 1
  fi
  cmd=$2
  if [ "$cmd" == "" ]; then
    cmd=bash
  fi
  COLUMNS=`tput cols`
  LINES=`tput lines`
  TERM=xterm
  kubectl exec -i -t $1 env COLUMNS=$COLUMNS LINES=$LINES TERM=$TERM $cmd
}
