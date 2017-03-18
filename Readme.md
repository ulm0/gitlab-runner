## About the image

[![build status](https://gitlab.com/klud/gitlab-runner/badges/master/build.svg)](https://gitlab.com/klud/gitlab-runner/commits/master)
This image is based on the [official repo](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner) of the GitLab Runner and built on alpine v3.5 to make it as lightweight as possible, the dumb-init was built on a Raspberry Pi running Hypriot OS, but you can build your own if you want to, and add it to the image, just clone the [Yelp/dumb-init repo](https://github.com/Yelp/dumb-init) and make sure to have a working compiler, the libc headers and defaults to glibc; install ```build-essential``` package if running a raspbian-based linux and just run ```make``` within the repo you just cloned.

## Usage

### Runner container setup


You need to mount a config volume into our gitlab-runner container to be used for configs and other resources:
```
docker run -d --name $(container_name) \
-v /path/to/config/file:/etc/gitlab-runner \
--restart always \
klud/gitlab-runner:armhf
```


Or you can use a config container to mount your custom data volume:
```
docker run -d --name $(container_name_data) \
    -v /etc/gitlab-runner \
    armhf/busybox:latest \
    /bin/true

docker run -d --name $(container_name) --restart always \
    --volumes-from gitlab-runner-config \
    klud/gitlab-runner:armhf
```


If you plan on using Docker as the method of spawning runners, you will need to mount your docker socket like this:
```
docker run -d --name $(container_name) --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /path/to/config/file:/etc/gitlab-runner \
  klud/gitlab-runner:armhf
```


You can approach this by using a docker-compose.yml file as well:
```
runner:
  image: klud/gitlab-runner:armhf
  container_name: $(container_name)
  restart: always
  volumes:
    - /path/to/config/file:/etc/gitlab-runner
    - /var/run/docker.sock:/var/run/docker.sock
```

### Register runner

Once the container is up and running, you need to register the runner in your GitLab instance


You can either do this:
```
docker exec -it $(container_name) gitlab-runner register

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
https://git.domain.com/ci
Please enter the gitlab-ci token for this runner
xxx
Please enter the gitlab-ci description for this runner
a-description-for-the-runner
INFO[0034] fcf5c619 Registering runner... succeeded
Please enter the executor: shell, docker, docker-ssh, ssh?
docker
Please enter the Docker image (eg. ruby:2.1):
ruby:2.1
INFO[0037] Runner registered successfully. Feel free to start it, but if it's
running already the config should be automatically reloaded!
```


OR this:
```
docker exec -it $(container_name) \
gitlab-runner register -n \
--url https://git.domain.com/ci \
--registration-token xxx \
--executor docker \
--description "a-description-for-the-runner" \
--docker-image "ruby:2.1" \
--docker-privileged
```


#### Tip:
 If you're going to build images on this runner you can use the docker image i built for this use-case as well, just type ```klud/docker:1.13-armhf``` or ```klud/docker:17.03-armhf``` when ```Please enter the Docker image``` in the first method or in ```--docker-image "image:tag"``` with the second method. There are also images for docker in docker (DinD) using ```klud/dind:1.13-armhf``` or ```klud/dind:17.03-armhf``` and for docker git ```klud/git:1.13-armhf``` or ```klud/git:17.03-armhf```

## Troubleshooting
In case you're using docker in docker in the runner, you may expirience some problems when talking to the docker socket: ```Cannot connect to the Docker daemon. Is the docker daemon running on this host?```.

So in order to address this issue you need to look within the config folder you mounted in the runner container, there will be config file inside and you need to add some lines and then restart the runner with ```docker restart $(container_name)```.

```
concurrent = 1
check_interval = 0

[[runners]]
  name = "runner description"
  url = "https://git.domain.com/ci"
  token = "xxx"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "klud/docker:1.13-armhf"
    ### IF YOU USED THE FIRST METHOD YOU NEED TO SET THE RUNNER IN PRIVILEGED MODE TO BE ABLE TO SPAWN JOBS
    privileged = true
    disable_cache = false
    ### YOU MAY NEED TO ADD THE CACHE DIR
    cache_dir = "cache"
    ### AND THE DOCKER SOCKET TO BE ABLE TO SPAWN JOBS AS WELL
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
  [runners.cache]
```
