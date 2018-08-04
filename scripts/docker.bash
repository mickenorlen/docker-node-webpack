#!/bin/bash
export $(egrep -v '^#' .env | xargs); # parse .env

function startup() { # Commands run at container startup
	yarn install
	yarn webpack $1
}

# Functions not listed in help as not prefixed by function
hasContainers() {
	echo "sudo docker container ls -a | grep -q $APP_NAME";
}

hasImages() {
	echo "sudo docker images | grep -q $COMPOSE_PROJECT_NAME";
}

isRunning() {
	echo "sudo docker container ls | grep -q $APP_NAME";
}

# Functions
function rmContainers() { # Rm containers
	if eval $(hasContainers); then
		stop;
		echo "Removing all $APP_NAME containers"
		sudo docker rm $(sudo docker container ls -a -f "name=$APP_NAME*" --format {{.ID}});
	fi
}

function rmImages() { # Rm images
	if eval $(hasImages); then
		echo "Removing all $COMPOSE_PROJECT_NAME images"
		if [[ $1 == 'force' ]];
			then sudo docker rmi -f $(sudo docker images -f "reference=$COMPOSE_PROJECT_NAME*" --format {{.ID}});
			else sudo docker rmi $(sudo docker images -f "reference=$COMPOSE_PROJECT_NAME*" --format {{.ID}});
		fi
	fi
}

function rmAll() { # Rm images and containers, $arg1 = force
	rmContainers;
	if [[ $1 == 'force' ]];
		then rmImages force;
		else rmImages;
	fi
}

function stop() { # Stop container
	if eval $(isRunning); then
		echo "Stopping all $COMPOSE_PROJECT_NAME containers";
		sudo docker stop $(sudo docker container ls -a -f "name=$COMPOSE_PROJECT_NAME*" --format {{.ID}});
	fi
}

function start() { # Start/restart container, $arg1 = prod, else dev
	stop;
	if [[ $1 == 'prod' ]]; then
		sudo docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d;
	else
		sudo docker-compose up -d;
	fi
}

function rebuild() { # Remove container and rebuild image, $arg1 = force
	rmAll $1;
	sudo docker-compose build
}

function logs() { # Get container logs
	if ! eval $(isRunning); then
		echo 'Not running';
	else
		sudo docker logs "$APP_NAME";
	fi
}

function bash() { # Enter container with bash
	if ! eval $(isRunning); then
		start;
	fi
	sudo docker exec -it "$APP_NAME" /bin/bash
}

function help() { # Show list of functions
    grep "^function" "./scripts/webpack.bash" | cut -d ' ' -f2- | sed 's/{ //g'
}
