FROM alpine:latest
LABEL maintainer "Pierre Ugaz <ulm0@innersea.xyz>"
ARG RUNNER_VERSION
ARG DOCKER_MACHINE_VERSION=0.16.2
COPY entrypoint /
RUN set -eux; \
	\
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
# arm32v6
		armhf) runnerArch='arm' ;; \
# arm32v7
		armv7) runnerArch='arm' ;; \
# arm64v8
		aarch64) runnerArch='arm64' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
    \  
        case "$apkArch" in \
# arm32v6
		armhf) machineArch='armhf' ;; \
# arm32v7
		armv7) machineArch='armhf' ;; \
# arm64v8
		aarch64) machineArch='aarch64' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	echo "Runner arch is ($runnerArch) and machineARch is ($machineArch)'
#    \

RUN adduser -D -S -h /home/gitlab-runner gitlab-runner && \
    apk add --no-cache \
    dumb-init=1.2.2-r1 \
    bash \
    ca-certificates \
    git \
    openssl \
    tzdata \
    git-lfs \
    wget 

# && \

RUN echo "Will download for arch $(runnerArch)" && \
    wget -q "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-${runnerArch}" -O /usr/bin/gitlab-runner 

# && \

RUN chmod +x /usr/bin/gitlab-runner && \
    ln -s /usr/bin/gitlab-runner /usr/bin/gitlab-ci-multi-runner && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    wget -q "https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-${machineArch}" -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    chmod +x /entrypoint && \
    docker-machine --version && \
    dumb-init --version && \
    git-lfs install --skip-repo && \
    git-lfs version
STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
