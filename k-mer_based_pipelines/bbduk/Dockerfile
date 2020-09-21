FROM openjdk:8-jre-alpine

RUN apk add bash \
  && wget -O BBMap.tar.gz https://sourceforge.net/projects/bbmap/files/BBMap_38.86.tar.gz/download \
  && tar xzf BBMap.tar.gz \
  && mv bbmap /usr/local \
  && rm -rf BBMap.tar.gz

ENV PATH=/usr/local/bbmap:$PATH