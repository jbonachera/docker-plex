#!/bin/bash

test -f /srv/plex/config/Plex\ Media\ Server/plexmediaserver.pid && rm -f /srv/plex/config/Plex\ Media\ Server/plexmediaserver.pid; 
# TODO: fix this tailf-insanity
for logfile in "Plex Media Server.log"; do
        tail -f --retry --follow=name  "/srv/plex/config/Plex Media Server/Logs/$logfile"  &
    done
ulimit -s $PLEX_MAX_STACK_SIZE && ./Plex\ Media\ Server
