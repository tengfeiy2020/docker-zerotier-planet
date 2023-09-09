FROM alpine:3.17 as builder

ARG ZT_PORT

ENV TZ=Asia/Shanghai

WORKDIR /app
ADD . /app

RUN sh cmd.sh

FROM alpine:3.17
WORKDIR /app

COPY --from=builder /app/ztncui /app/ztncui
COPY --from=builder /app/bin /app/bin
COPY --from=builder /app/zerotier-one.port /app/zerotier-one.port
COPY --from=builder /var/lib/zerotier-one /var/lib/zerotier-one

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache npm zerotier-one

VOLUME [ "/app","/var/lib/zerotier-one" ]

CMD /bin/sh -c "cd /var/lib/zerotier-one && ./zerotier-one -p`cat /app/zerotier-one.port` -d; cd /app/ztncui/src;npm start"
