#!/bin/bash

# Some docker func's some shamelessly borrowed from jessfraz some made up myself.


export DOCKER_REPO_PREFIX=jvzantvoort

#
# Helper Functions
#
function dcleanup()
{
	local containers
	mapfile -t containers < <(docker ps -aq 2>/dev/null)
	docker rm "${containers[@]}" 2>/dev/null
	local volumes
	mapfile -t volumes < <(docker ps --filter status=exited -q 2>/dev/null)
	docker rm -v "${volumes[@]}" 2>/dev/null
	local images
	mapfile -t images < <(docker images --filter dangling=true -q 2>/dev/null)
	docker rmi "${images[@]}" 2>/dev/null
}

function del_stopped()
{
	local name=$1
	local state
	state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

	if [[ "$state" == "false" ]]; then
		docker rm "$name"
	fi
}

function rmctr()
{
	# shellcheck disable=SC2068
	docker rm -f $@ 2>/dev/null || true
}

function relies_on()
{
	for container in "$@"; do
		local state
		state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

		if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
			echo "$container is not running, starting it for you."
			$container
		fi
	done
}

function cadvisor()
{
	docker run -d \
		--restart always \
		-v /:/rootfs:ro \
		-v /var/run:/var/run:rw \
		-v /sys:/sys:ro  \
		-v /var/lib/docker/:/var/lib/docker:ro \
		-p 1234:8080 \
		--name cadvisor \
		google/cadvisor

	hostess add cadvisor "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' cadvisor)"
	browser-exec "http://cadvisor:8080"
}

function dgcloud()
{
	docker run --rm -it \
		-v "${HOME}/.gcloud:/root/.config/gcloud" \
		-v "${HOME}/.ssh:/root/.ssh:ro" \
		-v "$(command -v docker):/usr/bin/docker" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--name gcloud \
		${DOCKER_REPO_PREFIX}/gcloud "$@"
}

function terraform()
{
	if [[ -n "$(which terraform)" ]]; then
		"$(which terraform)" "$@"
	else
		docker run -it --rm \
			-v "${HOME}:${HOME}:ro" \
			-v "$(pwd):/usr/src/repo" \
			-v /tmp:/tmp \
			--workdir /usr/src/repo \
			--log-driver none \
			-e GOOGLE_APPLICATION_CREDENTIALS \
			-e SSH_AUTH_SOCK \
			${DOCKER_REPO_PREFIX}/terraform "$@"
	fi
}

function black()
{
  docker run --rm --volume "$(pwd):/src" --workdir /src pyfound/black:latest_release black "$@"
}

function shellcheck()
{
  docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable "$@"
}

function inspec {
  docker run -it --rm -v "$(pwd)":/share chef/inspec "$@"
}

