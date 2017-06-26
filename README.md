# docker-tls-proxy

![License][license]
![GitHub Issues][github-issues]
![GitHub Stars][github-stars]
![GitHub Forks][github-forks]
![Docker Build][docker-build]
![Docker Build][docker-build-status]
![Docker Pulls][docker-pulls]
[![Twitter](https://img.shields.io/twitter/url/https/github.com/flaccid/docker-tls-proxy.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=%5Bobject%20Object%5D)

A simple reverse proxy using NGINX in Docker for terminating TLS/SSL.

## Usage

### Build

    $ docker build -t flaccid/tls-proxy .

### Run

An example:

```
docker run \
  -itd \
  -e UPSTREAM_HOST=icanhazip.com \
  -e FORCE_HTTPS=true \
  -e WEBSOCKET_SUPPORT=true \
  -p 8877:80 \
  -p 8878:443 \
    flaccid/tls-proxy
```

#### Runtime Environment Variables

There should be a reasonable amount of flexibility using the available variables. If not please raise an issue so your use case can be covered!

- `SELF_SIGNED` - generate and use a self-signed certificate (`true` or `false`, default is `false`)
- `FORCE_HTTPS` - force (redirect plain HTTP requests) HTTPs (`true` or `false`, default is `false`)
- `LISTEN_PORT` - listen port for the NGINX SSL port (default is `443`)
- `UPSTREAM_HOST` - the hostname or IP to reverse proxy to (default is `localhost`)
- `UPSTREAM_PORT` - the upstream host's port (default is `80`)
- `WEBSOCKET_SUPPORT` - enable websocket support (default is `false`)
- `ENABLE_SPDY` - enable SPDY support (default is `false`)

### Push to DockerHub

    $ docker push flaccid/tls-proxy

License and Authors
-------------------
- Author: Chris Fordham (<chris@fordham-nagy.id.au>)

```text
Copyright 2017, Chris Fordham

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[license]: https://img.shields.io/badge/license-Apache%202-blue.svg
[github-issues]: https://img.shields.io/github/issues/flaccid/docker-tls-proxy.svg
[github-forks]: https://img.shields.io/github/forks/flaccid/docker-tls-proxy.svg
[github-stars]: https://img.shields.io/github/stars/flaccid/docker-tls-proxy.svg
[docker-build]: https://img.shields.io/docker/automated/flaccid/tls-proxy.svg
[docker-build-status]: https://img.shields.io/docker/build/flaccid/tls-proxy.svg
[docker-pulls]: https://img.shields.io/docker/pulls/flaccid/tls-proxy.svg
