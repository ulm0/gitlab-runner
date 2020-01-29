FROM ubuntu:18.04
LABEL maintainer "Pierre Ugaz <ulm0@innersea.xyz>"
ARG RUNNER_VERSION
ARG DOCKER_MACHINE_VERSION=0.16.2
ENV DEBIAN_FRONTEND=noninteractive
COPY entrypoint /
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https curl git vim nano tzdata git-lfs dumb-init && \
    wget -q "https://packages.gitlab.com/runner/gitlab-runner/packages/ubuntu/bionic/gitlab-runner_${RUNNER_VERSION}_armhf.deb/download" -O /tmp/gitlab-runner_armhf.deb && \
    dpkg -i /tmp/gitlab-runner_armhf.deb; \
    apt-get update &&  \
    apt-get -f install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /tmp/gitlab-runner_armhf.deb && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    wget -q "https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf" -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    chmod +x /entrypoint && \
    docker-machine --version && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init --version && \
    git-lfs install --skip-repo && \
    git-lfs version
STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
