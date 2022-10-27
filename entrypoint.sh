#!/bin/sh

# args
AUUID="7f6f066f-d896-4ad4-8499-2f8955d3cc90"
CADDYIndexPage="https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html"
#CONFIGCADDY="https://raw.githubusercontent.com/jssame/cxdxy/main/etc/Caddyfile"
#CONFIGXRAY="https://raw.githubusercontent.com/jssame/cxdxy/main/etc/xray.json"
ParameterSSENCYPT="chacha20-ietf-poly1305"
#PORT=80

# configs
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
#wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget $CADDYIndexPage -O /usr/share/caddy/index.html 
#wget -qO- $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
#wget -qO- $CONFIGXRAY | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json
cat /conf/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat /conf/xray.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json 

# start
tor &
/xray -config /xray.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile