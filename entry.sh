#!/bin/sh -e

: "${ENABLE_HTTP2:=false}"
: "${ENABLE_WEBSOCKET:=false}"
: "${FORCE_HTTPS:=false}"
: "${LISTEN_PORT:=443}"
: "${SELF_SIGNED:=false}"
: "${SELF_SIGNED_SUBJECT:=/C=AQ/ST=Antarctica/L=McMurdo Station/O=The Penguin Resistance/OU=Fish Department/CN=localhost}"
: "${SERVER_NAME:=_}"
: "${UPSTREAM_HOST:=localhost}"
: "${UPSTREAM_PORT:=80}"

# create a self-signed certificate if needed
if [ "$SELF_SIGNED" = 'true' ]; then
  if [ ! -e /etc/nginx/cert.pem ]; then
    echo '> using a self-signed certificate'
    openssl req -nodes -x509 \
      -newkey rsa:2048 \
      -days 365 \
      -keyout /etc/nginx/key.pem \
      -out /etc/nginx/cert.pem \
      -subj "$SELF_SIGNED_SUBJECT"
  fi
else
  if ([ -z "$TLS_CERTIFICATE" ] || [ -z "$TLS_KEY" ]); then
    echo '$TLS_CERTIFICATE and $TLS_KEY are not set, exiting!'
    exit 1
  else
    echo "$TLS_CERTIFICATE" > /etc/nginx/cert.pem
    echo "$TLS_KEY" > /etc/nginx/key.pem
  fi
fi

# print out the certificate for informational purposes
openssl x509 -in /etc/nginx/cert.pem -text -noout

# nginx re-configuration
echo '> reconfigure nginx'
[ "$ENABLE_HTTP2" = 'true' ] && http2=' http2'
sed -i "s/server localhost:80/server $UPSTREAM_HOST:$UPSTREAM_PORT/" /etc/nginx/conf.d/02-https.conf
sed -i "s/listen 443 ssl/listen $LISTEN_PORT ssl$http2/" /etc/nginx/conf.d/02-https.conf
sed -i "s/server_name _/server_name $SERVER_NAME/" /etc/nginx/conf.d/02-https.conf

if [ "$FORCE_HTTPS" = 'true' ]; then
  echo '>> force https'
  cat <<EOF> /etc/nginx/conf.d/01-http.conf
server {
  listen 80;
  server_name $SERVER_NAME;
  return 301 https://\$host\$request_uri;
}
EOF
fi

if [ "$ENABLE_WEBSOCKET" = 'true' ]; then
  echo '>> websocket support on'
  cat <<'EOF'> /etc/nginx/conf.d/websocket.conf
map $http_upgrade $connection_upgrade {
    default Upgrade;
    ''      close;
}
EOF
  tmpf=$(mktemp)
  cat <<'EOF'> "$tmpf"
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Port $server_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
      # This allows the ability for the execute shell window to remain open for up to 15 minutes. Without this parameter, the default is 1 minute and will automatically close.
      proxy_read_timeout 900s;
EOF
  sed -i "/proxy_pass/r $tmpf" /etc/nginx/conf.d/02-https.conf
  rm -f "$tmpf"
fi

echo '--/etc/nginx/nginx.conf--'
cat /etc/nginx/nginx.conf
echo '---'

for f in /etc/nginx/conf.d/*.conf ; do
  echo "--$f--"
  cat "$f"
  echo '---'
done

echo "> $@" && exec "$@"
