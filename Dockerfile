FROM armhf/alpine:3.5
LABEL maintainer "Klud <pierre.ugazm@gmail.com>"
COPY dumb-init-1.2.0/dumb-init /usr/bin/
RUN apk add --no-cache \
    bash \
    git \
    ca-certificates \
    openssl \
    wget && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init -V && \
    wget -q https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v9.2.0/binaries/gitlab-ci-multi-runner-linux-arm -O /usr/bin/gitlab-ci-multi-runner  && \
    chmod +x /usr/bin/gitlab-ci-multi-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.10.0/docker-machine-Linux-armhf -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache upx && \
    cd /usr/bin/ && \
    upx -9v gitlab-ci-multi-runner && \
    ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
    upx -9v docker-machine && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    apk del upx
ADD entrypoint /
RUN chmod +x /entrypoint
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]