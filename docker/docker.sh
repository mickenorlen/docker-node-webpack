#!/bin/sh
export $(egrep -v '^#' .env | xargs); # parse .env

function help() { # Show list of functions
    grep "^function" "./scripts/docker.sh" | cut -d ' ' -f2- | sed 's/{ //g'
}

# Functions not listed in help as not prefixed by function
hasContainers() {
	if [[ $1 == 'prod' ]]; then
		echo "sudo docker container ls -a | grep -q ${APP_NAME}_prod";
	else
		echo "sudo docker container ls -a | grep -q ${APP_NAME}_dev";
	fi
}

hasImages() {
	echo "sudo docker images | grep -q $BUILD_IMAGE";
}

isRunning() {
	if [[ $1 == 'prod' ]]; then
		echo "sudo docker container ls | grep -q ${APP_NAME}_prod";
	else
		echo "sudo docker container ls | grep -q ${APP_NAME}_dev";
	fi
}


# FUNCTIONS
function ls() { # List containers and images
	sudo docker ps
	echo
	sudo docker images
}

function rmc() { # Rm containers, $arg1 = prod
	if [[ $1 == 'prod' ]] && eval $(hasContainers prod); then
		stop prod;
			echo "Removing ${APP_NAME}_prod containers"
		sudo docker rm $(sudo docker container ls -a -f "name=${APP_NAME}_prod*" --format {{.ID}});
	elif [[ $1 != 'prod' ]] && eval $(hasContainers); then
		stop;
		echo "Removing ${APP_NAME}_dev containers"
		sudo docker rm $(sudo docker container ls -a -f "name=${APP_NAME}_dev*" --format {{.ID}});
	fi
}

function rmi() { # Rm image
	if eval $(hasImage); then
		echo "Removing $BUILD_IMAGE"
		sudo docker rmi $(sudo docker images -f "reference=$BUILD_IMAGE" --format {{.ID}});
	fi
}

function rebuild() { # Remove container and rebuild image, $arg1 = force
	#rmAll $1;
	sudo docker build $BUILD_PATH -t $BUILD_IMAGE
}

function push() { # Push rebuilt image
	sudo docker login
	sudo docker push $BUILD_IMAGE
}

# Containers
function stop() { # Stop container
	if [[ $1 == 'prod' ]] &&  eval $(isRunning prod); then
		echo "Stopping ${APP_NAME}_prod containers";
		sudo docker stop $(sudo docker container ls -af "name=${APP_NAME}_prod*" --format {{.ID}});
	elif [[ $1 != 'prod' ]] && eval $(isRunning); then
		echo "Stopping ${APP_NAME}_dev containers";
		sudo docker stop $(sudo docker container ls -af "name=${APP_NAME}_dev*" --format {{.ID}});
	fi
}

function start() { # Start/restart container, $arg1 = prod, else dev
	if [[ $1 == 'prod' ]]; then
		stop prod;
		sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d;
	else
		stop
		sudo docker-compose up -d;
	fi
}

function logs() { # Get container log, $arg1 = prod
	if [[ $1 == 'prod' ]] &&  eval $(isRunning prod); then
		sudo docker logs $(sudo docker container ls -a -f "name=${APP_NAME}_prod_web*" --format {{.ID}});
	elif [[ $1 != 'prod' ]] && eval $(isRunning); then
		sudo docker logs $(sudo docker container ls -a -f "name=${APP_NAME}_dev_web*" --format {{.ID}});
	else
		echo "Not running"
	fi
}

function clearlogs() { # Clear logs of container
	if [[ $1 == 'prod' ]] && eval $(hasContainers prod); then
		sudo truncate -s 0 $(sudo docker inspect --format='{{.LogPath}}' ${APP_NAME}_prod_web)
	elif [[ $1 != 'prod' ]] && eval $(hasContainers); then
		sudo truncate -s 0 $(sudo docker inspect --format='{{.LogPath}}' ${APP_NAME}_dev_web)
	else
		echo "No container"
	fi
}

function bash() { # Enter container with bash, $arg = prod
	if [[ $1 == 'prod' ]] &&  eval $(isRunning prod); then
		sudo docker exec -it "${APP_NAME}_prod_web" /bin/bash
	elif [[ $1 != 'prod' ]] && eval $(isRunning); then
		sudo docker exec -it "${APP_NAME}_dev_web" /bin/bash;
	else
		echo "Not running"
	fi
}


