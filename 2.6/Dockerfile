FROM mongo:2.6
MAINTAINER erhankesken@gmail.com

ENV REPLICATION_SET_NAME=rs-test \
  KEY_FILE_CONTENT=""

COPY env-entrypoint.sh /env-entrypoint.sh
RUN chmod +x /env-entrypoint.sh

ENTRYPOINT ["/env-entrypoint.sh"]
