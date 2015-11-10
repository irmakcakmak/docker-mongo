#!/bin/bash

MONGO_CMD=mongod
mkdir -p /data/db/$REPLICATION_SET_NAME/
chown -R mongodb:mongodb /data/db/$REPLICATION_SET_NAME/

if [ "z$SHARDING_CONFIGDB" != "z" ]; then
  MONGO_CMD=mongos
  cat <<EOF >> /etc/mongod.conf
sharding:
  configDB: $SHARDING_CONFIGDB
EOF
else
  if [ "z$REPLICATION_SET_NAME" != "z" ]; then
    cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/$REPLICATION_SET_NAME/

replication:
  replSetName: $REPLICATION_SET_NAME

EOF
  else
    cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/

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
  
  if [ "z$CONFIGSVR" = "ztrue" ]; then
    cat <<EOF >> /etc/mongod.conf
sharding:
  clusterRole: configsvr
EOF
  fi
fi

if [ "z$NET_PORT" != "z" ]; then
  cat <<EOF >> /etc/mongod.conf
net:
   port: $NET_PORT
EOF
fi
 
/entrypoint.sh $MONGO_CMD -f /etc/mongod.conf

