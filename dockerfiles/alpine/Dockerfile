FROM alpine:3.7
LABEL maintainer "Mauricio Ugaz <ulm0@innersea.xyz>"
ARG RUNNER_VERSION
ARG DOCKER_MACHINE_VERSION=0.14.0
COPY entrypoint /
RUN adduser -D -S -h /home/gitlab-runner gitlab-runner && \
    apk add --no-cache \
    dumb-init=1.2.0-r0 \
    bash \
    ca-certificates \
    git \
    openssl \
    tzdata \
    wget && \
    wget -q "https://gitlab-runner-downloads.s3.amazonaws.com/v${RUNNER_VERSION}/binaries/gitlab-runner-linux-arm" -O /usr/bin/gitlab-runner && \
    chmod +x /usr/bin/gitlab-runner && \
    ln -s /usr/bin/gitlab-runner /usr/bin/gitlab-ci-multi-runner && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    wget -q "https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf" -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    docker-machine --version && \
    chmod +x /entrypoint && \
    dumb-init --version
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
