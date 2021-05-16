FROM nginx:1.20-alpine

# Metadata about the docker image
LABEL name="tor-nginx-proxy"
LABEL version="1.0.0-beta-1.0"
LABEL maintainer="Harshit Budhraja (https://github.com/harshit-budhraja)"

# Update packages and install tor
RUN apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/community/ add \
    tor && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Copy nginx and tor configurations
COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY torrc /etc/tor/torrc

# Add script to start tor
COPY start-tor.sh /docker-entrypoint.d/40-start-tor.sh
RUN chmod +x /docker-entrypoint.d/40-start-tor.sh