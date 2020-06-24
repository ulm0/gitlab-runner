# GitLab Runner for ARM

[![pipeline status](https://gitlab.com/ulm0/gitlab-runner/badges/master/pipeline.svg)](https://gitlab.com/ulm0/gitlab-runner/-/commits/master) [![Docker Pulls](https://img.shields.io/docker/pulls/klud/gitlab-runner.svg)](https://hub.docker.com/r/klud/gitlab-runner/) [![Docker Pulls](https://img.shields.io/docker/stars/klud/gitlab-runner.svg)](https://hub.docker.com/r/klud/gitlab-runner/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Tags

[![](https://images.microbadger.com/badges/version/klud/gitlab-runner:alpine.svg)](https://microbadger.com/images/klud/gitlab-runner:alpine "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/klud/gitlab-runner:ubuntu.svg)](https://microbadger.com/images/klud/gitlab-runner:ubuntu "Get your own version badge on microbadger.com")

**Notes:**
  - Alpine is the default image, when running `docker pull klud/gitlab-runner` this one is going to be downloaded depending on the runner arch, at the moment only arm is supported.
  <!-- - Currently only the alpine image is multi-arch. -->

## About the image

These image are built for ARM devices, based on the [official repo](https://gitlab.com/gitlab-org/gitlab-runner) of the GitLab Runner, both Alpine and Ubuntu flavors are available.

## Overview

### Runner container setup

You need to mount a config volume into our gitlab-runner container to be used for configs and other resources:

```sh
docker run -d --name arm-runner \
-v $(pwd)/.runner:/etc/gitlab-runner \
--restart=always \
klud/gitlab-runner
```

Or you can use a config container to mount your custom data volume:

```sh
docker run -d --name runner-config \
    -v /etc/gitlab-runner \
    armhf/busybox \
    /bin/true

docker run -d --name arm-runner --restart=always \
    --volumes-from runner-config \
    klud/gitlab-runner
```

If you plan on using the Docker executor, it is necessary to mount the Docker socket this way:

```sh
docker run -d --name arm-runner --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/.runner:/etc/gitlab-runner \
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
    - $(pwd)/.runner:/etc/gitlab-runner
    - /var/run/docker.sock:/var/run/docker.sock
```

### Register runner

Once the container is up and running, it is time to register the runner on the GitLab server

You can either do this:

```sh
docker exec -it arm-runner gitlab-runner register

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
https://gitlab.domain.tld
Please enter the gitlab-ci token for this runner
XXXXXXXXXXXXXXXXXXXX
Please enter the gitlab-ci description for this runner
ARM Runner by ulm0
INFO[0034] fcf5c619 Registering runner... succeeded
Please enter the executor: shell, docker, docker-ssh, ssh?
docker
Please enter the Docker image (eg. ruby:2.1):
docker:17.12
INFO[0037] Runner registered successfully. Feel free to start it, but if it's
running already the config should be automatically reloaded!
```

Or this:

```sh
docker exec -it arm-runner \
gitlab-runner register -n \
--url https://gitlab.domain.tld \
--registration-token XXXXXXXXXXXXXXXXXXXX \
--executor docker \
--description "ARM Runner by ulm0" \
--docker-image "docker:17.12" \
--tag-list "docker,arm" \
--docker-privileged
```

## Troubleshooting

If you're using `docker in docker` in the runner, you may expirience some problems when talking to the docker socket

```sh
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
```

In order to address this issue you need to look within the config folder you mounted in the runner container, there will be a config file inside, you need to add some lines and then restart the runner with `docker restart arm-runner`.

```toml
concurrent = 1
check_interval = 0

[[runners]]
  name = "ARM Runner by ulm0"
  url = "https://gitlab.domain.tld"
  token = "XXXXXXXXXXXXXXXXXXXX"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "docker:17.12"
    ### IF YOU USED THE FIRST METHOD YOU NEED TO SET
    ### THE RUNNER IN PRIVILEGED MODE TO BE ABLE TO SPAWN JOBS
    privileged = true
    disable_cache = false
    ### YOU MAY NEED TO ADD THE CACHE DIR
    cache_dir = "cache"
    ### AND THE DOCKER SOCKET TO BE ABLE TO SPAWN JOBS AS WELL
    volumes = ["/var/run/docker.sock:/var/run/docker.sock","/cache"]
  [runners.cache]
```

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/for-you.svg)](https://forthebadge.com)