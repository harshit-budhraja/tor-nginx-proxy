<p align="center">
  <img width="300px" src="https://upload.wikimedia.org/wikipedia/commons/8/8f/Tor_project_logo_hq.png">
</p>

# Tor-nginx-proxy

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/harshit-budhraja/tor-nginx-proxy?include_prereleases)
![license](https://img.shields.io/badge/license-GPLv3.0-brightgreen.svg?style=flat)
[![Docker Hub pulls](https://img.shields.io/docker/pulls/harshitbudhraja/tor-nginx-proxy.svg)](https://hub.docker.com/r/harshitbudhraja/tor-nginx-proxy/)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/harshitbudhraja/tor-nginx-proxy/latest)

[![Docker Hub badge](http://dockeri.co/image/harshitbudhraja/tor-nginx-proxy)](https://hub.docker.com/r/harshitbudhraja/tor-nginx-proxy/)

The super easy and quick way to setup your web presence on the [Tor](https://www.torproject.org) network using [NGINX's](https://www.nginx.com) [proxy_pass](https://dev.to/danielkun/nginx-everything-about-proxypass-2ona) directive inside a [Docker](https://en.wikipedia.org/wiki/Docker_(software)) [container](https://en.wikipedia.org/wiki/Container_(virtualization)).


## Usage

1. Setup the proxy server at the **first time**

```sh
docker run --restart=unless-stopped --rm --name tor-nginx-proxy -e "NGINX_PORT=80" -e "NGINX_PROXY_URL=<YOUR_APP_URL>" -p 3000:80 -v "/absolute/path/to/volume/dir/on/host/tor:/var/lib/tor/" harshitbudhraja/tor-nginx-proxy:latest
```

- With parameter `--restart=unless-stopped` the container will always restart on daemon startup or when it fails unexpectedly, unless it's explicitly stopped.
- `--rm` parameter tells the docker daemon to remove dangling containers associated with this service once they're stopped.
- Environment variable `NGINX_PORT`: Use NGINX port `80` inside the docker container to listen to, do not change it unless you know the implications.
- Environment variable `NGINX_PROXY_URL`: Here's where you configure your proxy pass. When a request arrives to the container which is running over the tor network through tor-nginx-proxy, it proxies those requests to your application which must be accessible over the url you provide. (Tip: don't forget to include the protocol `http://` or `https://` and the port that your application is serving from).
- Port mapping `3000:80` is optional. You might want to access the proxied service in some cases.
- Volume mount to `"/absolute/path/to/volume/dir/on/host/tor:/var/lib/tor/"` is necessary, as this will help you persist your vanity .onion url across multiple deployments of your proxy.

If you have already set up the instance before *(not the first time)* but it's in a *stopped state*, you can just start it instead of creating a new one:

```sh
docker start tor-nginx-proxy
```

2. Make sure it's running, it usually takes a short time to bootstrap `Tor`:

```sh
$ docker logs tor-nginx-proxy
.
.
.
Jan 10 01:06:59.000 [notice] Bootstrapped 85%: Finishing handshake with first hop
Jan 10 01:07:00.000 [notice] Bootstrapped 90%: Establishing a Tor circuit
Jan 10 01:07:02.000 [notice] Tor has successfully opened a circuit. Looks like client functionality is working.
Jan 10 01:07:02.000 [notice] Bootstrapped 100%: Done
```

3. Once you see that Tor is bootstrapped in your container logs, you can get the vanity .onion url on which your proxy
is serving from the file by reading it in any editor or terminal itself: `cat /absolute/path/to/volume/dir/on/host/tor/hidden_service/hostname`.

4. Finally, open up the [Tor Browser](https://www.torproject.org/download/) and head over to your .onion link to check if it's working.


**NOTE:** Do not remove or alter the contents of the `/absolute/path/to/volume/dir/on/host/tor/` directory while the service is running, as this is directly mounted to your container.


## Using custom vanity .onion urls

`tor-nginx-proxy` supports custom onion urls out-of-the-box. Just replace the contents of `/absolute/path/to/volume/dir/on/host/tor/hidden_service/` with your own `hostname`, `public key` and `private key` binaries and restart the container.

As Tor is moving towards v3 .onion urls, it's advised to use tools like [mkp224o](https://github.com/cathugger/mkp224o) which helps you generate the new, longer and secured .onion urls.


## Support The Tor Project

**For the Tor project sustainability, I strongly encourage you to help [setup Tor bridges/exit nodes](https://trac.torproject.org/projects/tor/wiki/TorRelayGuide)([**script**](https://github.com/PeterDaveHello/ubuntu-tor-simply-setup)) and [donate](https://donate.torproject.org/) money to the Tor project *(Not this nginx-proxy project)* as and when you have the ability/capacity!**