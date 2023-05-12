FROM debian:11.7-slim

ARG ZT_PORT

ENV TZ=Asia/Shanghai

WORKDIR /app
ADD . /app

RUN ./script/init.sh


CMD /bin/sh -c "cd /var/lib/zerotier-one && ./zerotier-one -p`cat /app/zerotier-one.port` -d; cd /app/ztncui/src;npm start"