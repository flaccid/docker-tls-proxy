FROM nginx:1-alpine

MAINTAINER Chris Fordham <chris@fordham-nagy.id.au>

ENV SELF_SIGNED false
ENV FORCE_HTTPS false
ENV LISTEN_PORT 443
ENV UPSTREAM_HOST localhost
ENV UPSTREAM_PORT 80
ENV WEBSOCKET_SUPPORT false
ENV ENABLE_SPDY false

RUN apk update && \
  apk add --no-cache --upgrade nginx openssl && \
  rm -rf /var/lib/apt/lists/* /etc/nginx/conf.d/*

COPY entry.sh /usr/local/bin/entry.sh
COPY nginx/conf.d /etc/nginx/conf.d

ENTRYPOINT ["/usr/local/bin/entry.sh"]

CMD ["nginx", "-g", "daemon off;"]
