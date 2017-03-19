FROM armhf/alpine:3.5

MAINTAINER Klud <pierre.ugazm@gmail.com>

RUN apk add --update --no-cache \
    git \
    bash \
    build-base

RUN git clone https://github.com/Yelp/dumb-init.git && \
    cd dumb-init && \
    git fetch origin 8e103bbb8b5ef5286b7800be011ab962dd7edb7a:refs/remotes/origin/v1.2.0 && \
    make && \
    mv dumb-init /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    cd .. && \
    rm -rf dumb-init

RUN apk del build-base && \
    apk add --update --no-cache \
    ca-certificates \
    openssl \
    wget

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
