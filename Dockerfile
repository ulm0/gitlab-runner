FROM armhf/alpine:3.5
LABEL maintainer "pierre.ugazm@gmail.com"

RUN apk add --no-cache \
    bash \
    git \
    ca-certificates \
    openssl \
    wget

COPY dumb-init-1.2.0/dumb-init /usr/bin/

RUN chmod +x /usr/bin/dumb-init && \
    dumb-init -V

RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v9.1.0/binaries/gitlab-ci-multi-runner-linux-arm && \
    chmod +x /usr/bin/gitlab-ci-multi-runner && \
    ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.10.0/docker-machine-Linux-armhf -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner

ADD entrypoint /
RUN chmod +x /entrypoint

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
