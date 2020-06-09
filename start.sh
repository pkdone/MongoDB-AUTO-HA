#/bin/sh
killall mongod && sleep 3
rm -rf /tmp/data && mkdir -p /tmp/data/r0/log /tmp/data/r1/log /tmp/data/r2/log

mongod --replSet TestRS --port 27000 --dbpath /tmp/data/r0 --fork --logpath /tmp/data/r0/log/mongod.log
mongod --replSet TestRS --port 27001 --dbpath /tmp/data/r1 --fork --logpath /tmp/data/r1/log/mongod.log
mongod --replSet TestRS --port 27002 --dbpath /tmp/data/r2 --fork --logpath /tmp/data/r2/log/mongod.log

