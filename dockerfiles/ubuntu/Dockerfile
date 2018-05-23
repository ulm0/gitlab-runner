FROM registry.gitlab.com/ulm0/ubuntu:16.04-arm
LABEL maintainer "Mauricio Ugaz <ulm0@innersea.xyz>"
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https curl git vim nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ARG RUNNER_VERSION
ARG DOCKER_MACHINE_VERSION=0.14.0
COPY dumb-init /usr/bin/
RUN wget -q "https://packages.gitlab.com/runner/gitlab-runner/packages/ubuntu/xenial/gitlab-runner_${RUNNER_VERSION}_armhf.deb/download" -O /tmp/gitlab-runner_armhf.deb && \
    dpkg -i /tmp/gitlab-runner_armhf.deb; \
    apt-get update &&  \
    apt-get -f install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/gitlab-runner_armhf.deb && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    docker-machine --version && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init --version
COPY entrypoint /
RUN chmod +x /entrypoint
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
