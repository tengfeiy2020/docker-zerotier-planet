FROM alpine:3.17 as builder

ARG ZT_PORT

ENV TZ=Asia/Shanghai

WORKDIR /app
ADD . /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update\
    && mkdir -p /usr/include/nlohmann/ && cd /usr/include/nlohmann/ && wget https://ghself.markxu.online/https://github.com/nlohmann/json/releases/download/v3.10.5/json.hpp \
    && apk add --no-cache git python3 npm make g++ zerotier-one linux-headers

RUN cd /app \
    && git clone --progress https://ghself.markxu.online/https://github.com/zerotier/ZeroTierOne.git --depth 1


CMD /bin/sh -c "./cmd.sh"