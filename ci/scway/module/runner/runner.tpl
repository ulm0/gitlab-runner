nodeArch="$(uname -m)"
case "$nodeArch" in
    armhf) runnerArch='arm' ;;
    armv7l) runnerArch='arm' ;;
    aarch64) runnerArch='arm64' ;;
    *) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;
esac

docker run -d --name runner --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /root/.runner:/etc/gitlab-runner klud/gitlab-runner
docker exec -it runner gitlab-runner register -n --locked=false --url ${gitlab_site} --registration-token ${gitlab_token} --executor docker --description "$runnerArch runner by ulm0" --docker-image "docker:17.12" --tag-list "docker,$runnerArch" --docker-privileged
sed -i -e 's|concurrent = 1|concurrent = 2|g' /root/.runner/config.toml
sed -i -e 's|"/cache"|"/var/run/docker.sock:/var/run/docker.sock","/cache"|g' /root/.runner/config.toml
docker restart runner
