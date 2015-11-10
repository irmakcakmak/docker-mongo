#!/bin/bash

mkdir -p /data/db/$REPLICATION_SET_NAME/
chown -R mongodb:mongodb /data/db/$REPLICATION_SET_NAME/

cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/$REPLICATION_SET_NAME/

replication:
  replSetName: $REPLICATION_SET_NAME

EOF

if [ "z$NET_PORT" != "z" ]; then
  cat <<EOF >> /etc/mongod.conf
net:
   port: $NET_PORT
EOF
fi

if [ "z$CONFIGSVR" != "ztrue" ]; then
  cat <<EOF >> /etc/mongod.conf
sharding:
  clusterRole: configsvr
EOF
fi

if [ "z$KEY_FILE_CONTENT" != "z" ]; then
  echo $KEY_FILE_CONTENT | tr ' ' '\n' > /etc/mongod-keyfile
  chmod 600 /etc/mongod-keyfile
  chown mongodb:mongodb /etc/mongod-keyfile
  cat <<EOF >> /etc/mongod.conf
security:
  keyFile: /etc/mongod-keyfile
EOF
fi

/entrypoint.sh -f /etc/mongod.conf
