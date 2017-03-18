FROM armhf/alpine:3.5

MAINTAINER Klud <pierre.ugazm@gmail.com>

ADD dumb-init /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

RUN apk add --update \
    bash \
    ca-certificates \
    git \
    openssl \
    wget && \
    rm -rf \
    /var/cache/apk/*

RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-arm && \
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
