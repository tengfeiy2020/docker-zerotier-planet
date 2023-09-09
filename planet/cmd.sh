init_env() {
    echo "$ZT_PORT" >/app/zerotier-one.port
    echo "ZT_PORT=$(cat /app/zerotier-one.port)"
    echo "初始化依赖"
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories &&
        apk update && mkdir -p /usr/include/nlohmann/ && cd /usr/include/nlohmann/ && wget https://ghself.markxu.online/https://github.com/nlohmann/json/releases/download/v3.10.5/json.hpp &&
        apk add --no-cache git python3 npm make g++ zerotier-one linux-headers
}

init_ztncui() {
    echo "初始化ztncui"
    mkdir /app -p && cd /app && git clone --progress https://ghself.markxu.online/https://github.com/key-networks/ztncui.git
    cp /app/binding.gyp /app/ztncui/src
    cd /app/ztncui/src
    npm install -g --progress --verbose node-gyp --registry=https://registry.npmmirror.com && npm install --registry=https://registry.npmmirror.com && echo 'HTTP_PORT=3443' >.env &&
        echo 'NODE_ENV=production' >>.env &&
        echo 'HTTP_ALL_INTERFACES=true' >>.env &&
        echo "ZT_ADDR=localhost:${ZT_PORT}" >>.env &&
        cp -v etc/default.passwd etc/passwd
}

init_zerotier() {
    echo "初始化zerotier"
    cd /app && git clone --progress https://ghself.markxu.online/https://github.com/zerotier/ZeroTierOne.git --depth 1 && zerotier-one -d && sleep 5s && ps -ef | grep zerotier-one | grep -v grep | awk '{print $1}' | xargs kill -9 &&
        cd /var/lib/zerotier-one && zerotier-idtool initmoon identity.public >moon.json && cd /app && python3 patch.py &&
        cd /var/lib/zerotier-one && zerotier-idtool genmoon moon.json && mkdir moons.d && cp ./*.moon ./moons.d &&
        cd /app/ZeroTierOne/attic/world/ && sh build.sh &&
        sleep 5s &&
        cd /app/ZeroTierOne/attic/world/ && ./mkworld &&
        mkdir /app/bin -p && cp world.bin /app/bin/planet &&
        TOKEN=$(cat /var/lib/zerotier-one/authtoken.secret) &&
        echo "ZT_TOKEN=$TOKEN" >>/app/ztncui/src/.env
}

check() {
    echo "检查环境安装状态"
    echo "检查zerotier"
    cat /app/zerotier-one.port
}

set -ex
init_env
init_ztncui
init_zerotier
check
