#!/bin/bash

#variable declarations
TOMCAT_CLASSPATH=/usr/local/tomcat/lib
OPENMRS_CLASSPATH=/usr/local/tomcat/webapps/openmrs/WEB-INF/lib
OPENMRS_CONTEXT=/usr/local/tomcat/webapps/openmrs/WEB-INF/web.xml

function build {
	echo "Building Image"
        docker build -t openmrs-platform:1.11.4 .
}
function run {
	echo "Stopping containers"
	docker-compose down
	echo "Starting Container"
	docker-compose up
}
function nameOfLastContainer {
	local CONTAINER=$(docker ps -l | awk '{print $NF}'| sed -n 2p)
	echo $CONTAINER
	return 0
}
function copyJaxenTest {
	local CONTAINER=$(nameOfLastContainer)
	echo $(docker exec -it $CONTAINER cp -v $TOMCAT_CLASSPATH/jaxen-1.1.6.jar  $OPENMRS_CLASSPATH)
	echo "realoding Context"
	docker exec -it $CONTAINER touch $OPENMRS_CONTEXT
}

if [ "$1" == "--fix-jaxen-and-log" ]; then
	echo $(copyJaxenTest)
	x-terminal-emulator -e docker logs --follow $(nameOfLastContainer) &
elif [ "$1" == "--logs" ]; then
	x-terminal-emulator -e docker logs --follow $(nameOfLastContainer) &
elif ["$1" == "--fix-jaxen"]; then
	echo $(copyJaxenTest)
else
echo $1
		#build
		#run
fi
