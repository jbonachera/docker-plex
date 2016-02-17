localbuild:
	docker build --no-cache=true --rm -t docker.io/jbonachera/plex .
get-image:
	docker pull jbonachera/plex:latest
clean-container:	
	docker stop plex
	docker rm plex
run:
	docker run --net=host -d --restart=always -v /srv/nas:/media --volumes-from plex-config --name plex  docker.io/jbonachera/plex 
update: get-image clean-container run
