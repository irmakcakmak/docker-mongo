#!/bin/bash

cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/$REPLICATION_SET_NAME/

replication:
  replSetName: $REPLICATION_SET_NAME

EOF

if [$KEY_FILE_CONTENT != '']; then
  mkdir -p /etc/mongod-keyfile
  echo $KEY_FILE_CONTENT | tr ' ' '\n' > /etc/mongod-keyfile
  chmod 600 /etc/mongod-keyfile
  cat <<EOF >> /etc/mongod.conf
security:
  keyFile: /etc/mongod-keyfile
EOF
fi

/entrypoint.sh -f /etc/mongod.conf
