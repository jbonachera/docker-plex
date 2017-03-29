FROM fedora:25
RUN useradd --system --uid 797 -M --shell /usr/sbin/nologin plex
RUN mkdir -p /srv/plex/config
RUN chown plex:plex /srv/plex/config
VOLUME /srv/plex/config

# Install required packages
RUN dnf install -y curl

# Download and install Plex (non plexpass). URL is "hard coded" to allow versionning. If you have a better idea, feel free to contribute.
ENV URL https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=redhat&X-Plex-Token=kjpKZ5fryZqzWD7kKQ2x
RUN curl -sL $URL  -o plexmediaserver.rpm && \
    dnf install -y ./plexmediaserver.rpm && \
    rm -f plexmediaserver.rpm

COPY run.sh /usr/local/bin/run.sh
RUN chown root:plex  /usr/local/bin/run.sh
USER plex

EXPOSE 32400

# the number of plugins that can run at the same time
ENV PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6

# ulimit -s $PLEX_MEDIA_SERVER_MAX_STACK_SIZE
ENV PLEX_MEDIA_SERVER_MAX_STACK_SIZE 3000

# location of configuration, default is
# "${HOME}/Library/Application Support"
ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR /srv/plex/config

ENV PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
ENV LD_LIBRARY_PATH /usr/lib/plexmediaserver
ENV TMPDIR /srv/plex/config/tmp/

WORKDIR /usr/lib/plexmediaserver
CMD  /usr/local/bin/run.sh
