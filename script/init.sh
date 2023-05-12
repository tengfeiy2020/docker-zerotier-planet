sed -i 's|deb.debian.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list

apt update
apt install curl git python3 npm make g++ procps -y

npm config set registry https://registry.npm.taobao.org
npm install -g node-gyp

# curl -s https://install.zerotier.com | bash
curl -s 'https://ghproxy.markxu.online/https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import &&
     if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" |  bash; fi

mkdir /app -p

cd /app && git clone https://ghproxy.markxu.online/https://github.com/key-networks/ztncui.git && cd /app/ztncui/src &&
     cp /app/patch/binding.gyp . && npm install &&
     echo 'HTTP_PORT=3443' >.env &&
     echo 'NODE_ENV=production' >>.env &&
     echo 'HTTP_ALL_INTERFACES=true' >>.env &&
     echo "ZT_ADDR=localhost:${ZT_PORT}" >>.env && echo "${ZT_PORT}" >/app/zerotier-one.port &&
     cp -v etc/default.passwd etc/passwd

cd /app && git clone -v https://ghproxy.markxu.online/https://github.com/zerotier/ZeroTierOne.git --depth 1 && zerotier-one -d && sleep 5s && ps -ef | grep zerotier-one | grep -v grep | awk '{print $2}' | xargs kill -9 &&
     cd /var/lib/zerotier-one && zerotier-idtool initmoon identity.public >moon.json && cd /app/patch && python3 patch.py &&
     cd /var/lib/zerotier-one && zerotier-idtool genmoon moon.json && mkdir moons.d && cp ./*.moon ./moons.d &&
     cd /app/ZeroTierOne/attic/world/ && sh build.sh &&
     sleep 5s &&
     cd /app/ZeroTierOne/attic/world/ && ./mkworld &&
     mkdir /app/bin -p && cp world.bin /app/bin/planet &&
     TOKEN=$(cat /var/lib/zerotier-one/authtoken.secret) &&
     echo "ZT_TOKEN=$TOKEN" >>/app/ztncui/src/.env

apt clean
apt autoremove
rm -rf /var/lib/apt/lists/*
