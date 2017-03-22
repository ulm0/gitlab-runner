FROM armhf/alpine:3.5

MAINTAINER Klud <pierre.ugazm@gmail.com>

ENV DUMB_INIT_SHA256 74486997321bd939cad2ee6af030f481d39751bc9aa0ece84ed55f864e309a3f

RUN apk add --update --no-cache \
    bash \
    build-base \
    git \
    ca-certificates \
    openssl \
    wget \
    curl

RUN set -x && \
    curl -fSL "https://github.com/Yelp/dumb-init/archive/v1.2.0.tar.gz" -o dumb-init.tar.gz && \
    echo "${DUMB_INIT_SHA256} *dumb-init.tar.gz" | sha256sum -c - && \
    tar -xzvf dumb-init.tar.gz && \
    cd dumb-init-1.2.0 && \
    make && \
    mv dumb-init /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init -V && \
    cd .. && \
    rm -rf dumb-init-1.2.0 && \
    rm -f dumb-init.tar.gz

RUN apk del build-base

RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v9.0.0/binaries/gitlab-ci-multi-runner-linux-arm && \
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
