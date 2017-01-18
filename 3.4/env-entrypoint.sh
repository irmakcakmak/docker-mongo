#!/bin/bash
echo $MONGO_MEMORY 
MONGO_CMD=mongod
mkdir -p /data/db/$REPLICATION_SET_NAME/
chown -R mongodb:mongodb /data/db/$REPLICATION_SET_NAME/

if [[ $MONGO_MEMORY ]]; then
  if (( "$MONGO_MEMORY" > 2048 )); then
    CACHE_SIZE="cacheSizeGB: $[(MONGO_MEMORY-1024)/1024]"
  else
    CACHE_SIZE="cacheSizeGB: 0.5"
  fi
fi

if [ "z$SHARDING_CONFIGDB" != "z" ]; then
  MONGO_CMD=mongos
  cat <<EOF >> /etc/mongod.conf
sharding:
  configDB: $SHARDING_CONFIGDB
EOF
else

  if [ "z$STORAGE_SMALLFILES" != "z" ]; then
    STORAGE_SMALLFILES="smallFiles: true"
  else
    STORAGE_SMALLFILES="smallFiles: false"
  fi

  if [[ ! $STORAGE_ENGINE ]]; then
    STORAGE_ENGINE="wiredTiger"
  fi
  echo "Storage engine is set to '$STORAGE_ENGINE'"
  ENGINE="engine: $STORAGE_ENGINE"
  if [[ $STORAGE_ENGINE == "mmapv1" ]]; then
    STORAGE_ENGINE="$STORAGE_ENGINE:
      $STORAGE_SMALLFILES"
  else
    STORAGE_ENGINE="$STORAGE_ENGINE:
      engineConfig: 
        journalCompressor: snappy
        directoryForIndexes: false
        $CACHE_SIZE"
  fi

  if [ "z$REPLICATION_SET_NAME" != "z" ]; then
    cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/$REPLICATION_SET_NAME/
  $ENGINE
  $STORAGE_ENGINE

replication:
  replSetName: $REPLICATION_SET_NAME

EOF
  else
    cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/
  $ENGINE
  $STORAGE_ENGINE
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

