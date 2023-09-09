set -ex
python3 patch.py
cd /app/ZeroTierOne
git pull
cd /app/ZeroTierOne/attic/world/ && sh build.sh
cat mkworld.cpp
sleep 5s
cd /app/ZeroTierOne/attic/world/ && ./mkworld
mkdir /app/bin -p && cp world.bin /app/bin/planet
