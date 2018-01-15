# GitLab Runner for ARM

[![build status](https://gitlab.com/klud/gitlab-runner/badges/master/build.svg)](https://gitlab.com/klud/gitlab-runner/commits-master) [![](https://images.microbadger.com/badges/version/klud/gitlab-runner.svg)](https://microbadger.com/images/klud/gitlab-runner "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klud/gitlab-runner:armhf.svg)](https://microbadger.com/images/klud/gitlab-runner:armhf "Get your own image badge on microbadger.com") [![Docker Pulls](https://img.shields.io/docker/pulls/klud/gitlab-runner.svg)](https://hub.docker.com/r/klud/gitlab-runner/)

## About the image

This image is aimed for ARM architectures, based on the [official repo](https://gitlab.com/gitlab-org/gitlab-runner) of the GitLab Runner and built on Alpine Linux to make it as lightweight as possible.

## Overview

### Runner container setup

You need to mount a config volume into our gitlab-runner container to be used for configs and other resources:

```sh
docker run -d --name arm-runner \
-v /path/to/config/file:/etc/gitlab-runner \
--restart=always \
klud/gitlab-runner
```

Or you can use a config container to mount your custom data volume:

```sh
docker run -d --name arm-runner-config \
    -v /etc/gitlab-runner \
    armhf/busybox \
    /bin/true

docker run -d --name arm-runner --restart=always \
    --volumes-from arm-runner-config \
    klud/gitlab-runner
```


If you plan on using the Docker executor, it is necessary to mount the Docker socket this way:

```sh
docker run -d --name arm-runner --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /path/to/config/file:/etc/gitlab-runner \
  klud/gitlab-runner
```

You can achieve this by using a `docker-compose.yml` file as well:

```yaml
version: "2"
runner:
  image: klud/gitlab-runner
  container_name: arm-runner
  restart: always
  volumes:
    - /path/to/config/file:/etc/gitlab-runner
    - /var/run/docker.sock:/var/run/docker.sock
```

### Register runner

Once the container is up and running, it is time to register the runner on the GitLab server

You can either do this:

```sh
docker exec -it arm-runner gitlab-runner register

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
https://git.domain.tld
Please enter the gitlab-ci token for this runner
XXX
Please enter the gitlab-ci description for this runner
ARM Runner by Klud
INFO[0034] fcf5c619 Registering runner... succeeded
Please enter the executor: shell, docker, docker-ssh, ssh?
docker
Please enter the Docker image (eg. ruby:2.1):
klud/docker:17.03.1
INFO[0037] Runner registered successfully. Feel free to start it, but if it's
running already the config should be automatically reloaded!
```

Or this:

```sh
docker exec -it arm-runner \
gitlab-runner register -n \
--url https://git.domain.tld \
--registration-token XXX \
--executor docker \
--description "ARM Runner by Klud" \
--docker-image "klud/docker:17.03.1" \
--tag-list "tag1,tag2" \
--docker-privileged
```

#### Tip

 If you're going to build images on this runner you can use the docker image I built for this use-case as well, just type `klud/docker:1.13.1` or `klud/docker:17.03.1` when `Please enter the Docker image` in the first method or in `--docker-image "image:tag"` with the second method. There are also images for docker in docker (DinD) using `klud/docker:1.13.1-dind` or `klud/docker:17.03.1-dind` and for docker git `klud/docker:1.13.1-git` or `klud/docker:17.03.1-git`

##### Dockerfiles and info about Docker in Docker images for ARM: [HERE](https://gitlab.com/ulm0/docker-arm)

## Troubleshooting

In case you're using docker in docker in the runner, you may expirience some problems when talking to the docker socket: `Cannot connect to the Docker daemon. Is the docker daemon running on this host?`.

So in order to address this issue you need to look within the config folder you mounted in the runner container, there will be a config file inside, you need to add some lines and then restart the runner with `docker restart arm-runner`.

```toml
concurrent = 1
check_interval = 0

[[runners]]
  name = "runner description"
  url = "https://git.domain.tld"
  token = "XXX"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "klud/docker:1.13.1"
    ### IF YOU USED THE FIRST METHOD YOU NEED TO SET
    ### THE RUNNER IN PRIVILEGED MODE TO BE ABLE TO SPAWN JOBS
    privileged = true
    disable_cache = false
    ### YOU MAY NEED TO ADD THE CACHE DIR
    cache_dir = "cache"
    ### AND THE DOCKER SOCKET TO BE ABLE TO SPAWN JOBS AS WELL
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
  [runners.cache]
```

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/for-you.svg)](https://forthebadge.com)