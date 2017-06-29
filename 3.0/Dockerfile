FROM mongo:3.0.15
MAINTAINER irmak@fastmail.com

ENV REPLICATION_SET_NAME="" \
    NET_PORT="27017" \
    SHARDING_CONFIGDB="" \
    KEY_FILE_CONTENT="" \
    STORAGE_SMALLFILES="" \
    CONFIGSVR="false" \
    STORAGE_ENGINE="wiredTiger" \
    MONGO_MEMORY=""

COPY env-entrypoint.sh /env-entrypoint.sh
RUN chmod +x /env-entrypoint.sh

ENTRYPOINT ["/env-entrypoint.sh"]

