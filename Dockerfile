FROM docker.io/library/eclipse-temurin:11-jre-jammy

ARG KAFKA_VERSION=3.4.0
ARG SCALA_VERSION=2.13
ARG KAFKA_ADVERTISED_HOST_NAME=localhost
ARG KAFKA_ADVERTISED_PORT=9092
ARG VCS_REF=unspecified
ARG BUILD_DATE=unspecified

LABEL org.label-schema.name="kafka" \
      org.label-schema.description="Apache Kafka" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vcs-url="https://github.com/dark0dave/kafka-docker" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.version="${SCALA_VERSION}_${KAFKA_VERSION}" \
      org.label-schema.schema-version="1.0" \
      maintainer="dark0dave"

ENV KAFKA_VERSION=$KAFKA_VERSION \
    SCALA_VERSION=$SCALA_VERSION \
    KAFKA_ADVERTISED_HOST_NAME=$KAFKA_ADVERTISED_HOST_NAME \
    KAFKA_ADVERTISED_PORT=$KAFKA_ADVERTISED_PORT \
    KAFKA_URL="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    KAFKA_HOME=/opt/kafka

EXPOSE $KAFKA_ADVERTISED_PORT

ENV PATH=${PATH}:${KAFKA_HOME}/bin

WORKDIR /opt

RUN apt-get update -qqq \
    && apt-get install -qqqy --no-install-recommends \
    curl \
    jq \
    net-tools \
    wget \
    && wget -q ${KAFKA_URL} -O - | tar -xz \
    && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/kafka"]

COPY entrypoint.sh /usr/bin

CMD ["entrypoint.sh"]
