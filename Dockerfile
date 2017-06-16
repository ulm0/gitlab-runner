FROM armhf/alpine:3.5
LABEL maintainer "Klud <pierre.ugazm@gmail.com>"
COPY dumb-init-1.2.0/dumb-init /usr/bin/
ADD binaries /usr/bin/
RUN apk add --no-cache \
    bash \
    git \
    ca-certificates \
    openssl \
    wget && \
    chmod +x /usr/bin/dumb-init && \
    chmod +x /usr/bin/gitlab-ci-multi-runner && \
    ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
    chmod +x /usr/bin/docker-machine && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
ADD entrypoint /
RUN chmod +x /entrypoint
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]