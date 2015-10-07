cat <<EOF >/etc/mongod.conf
storage:
  dbPath: /data/db/$REPLICATION_SET_NAME/

replication:
  replSetName: $REPLICATION_SET_NAME

security:
  keyFile: /etc/mongodb/ebrandvalue-mongodb-keyfile
EOF

/entrypoint.sh -f /etc/mongod.conf
