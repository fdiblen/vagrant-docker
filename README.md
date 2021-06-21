# Vagrant docker box

## environment

Bash:

```shell
export VAGRANT_HOME=.vagrant.d
export VAGRANT_DOTFILE_PATH=.vagrant
```

Fish shell:

```shell
set -x VAGRANT_HOME .vagrant.d
set -x VAGRANT_DOTFILE_PATH .vagrant
```

## start

```shell
vagrant up --provider=docker --no-parallel
```

## stop

```shell
vagrant destroy --force
```

## multi-arch

```shell
export DOCKER_BUILDKIT=1
docker buildx create --use --name=qemu
qemu
docker buildx inspect --bootstrap
```

```shell
docker buildx build --tag fdiblen/vagrant-docker --platform=linux/amd64,linux/arm64
```

## clean up

```shell
docker system prune --all --volumes --force
```

## ssh

```shell
vagrant ssh server2
```
