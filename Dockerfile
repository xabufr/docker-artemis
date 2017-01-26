FROM alpine:3.5

RUN apk --no-cache add bash openjdk8-jre wget

ENV VERSION 1.5.2
RUN mkdir /opt && cd /opt && \
wget https://archive.apache.org/dist/activemq/activemq-artemis/$VERSION/apache-artemis-$VERSION-bin.tar.gz && \
tar xf apache-artemis-$VERSION-bin.tar.gz && \
rm apache-artemis-$VERSION-bin.tar.gz && \
./apache-artemis-$VERSION/bin/artemis create broker \
                                      --password artemis \
                                      --user artemis \
                                      --allow-anonymous \
                                      --role amq && \
cd ./apache-artemis-$VERSION && \
rm -rf examples

EXPOSE 61616
VOLUME ["/opt/broker/data"]

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["artemis-server"]
