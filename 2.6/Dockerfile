FROM mongo:2.6
MAINTAINER erhankesken@gmail.com

ENV REPLICATION_SET_NAME=rs-test

COPY env-entrypoint.sh /env-entrypoint.sh
ENTRYPOINT ["/env-entrypoint.sh"]
