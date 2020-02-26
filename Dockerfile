FROM alpine:latest

ENV VERSION=1.0.0

ADD https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-${VERSION}-x86_64-linux.tgz \
  /tmp/ookla-speedtest.tgz

RUN apk add --no-cache tar && \
    tar xvfz /tmp/ookla-speedtest.tgz -C /usr/local/bin speedtest && \
    rm -rf /tmp/ookla-speedtest.tgz && \
    adduser -D speedtest && \
    su speedtest -c "speedtest --accept-license --accept-gdpr" && \
    apk del tar

USER speedtest

ENTRYPOINT ["/usr/local/bin/speedtest"]
