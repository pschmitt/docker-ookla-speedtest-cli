FROM alpine:latest

ARG VERSION=1.0.0
ENV SPEEDTEST_VERSION=${VERSION}

# ADD https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-${VERSION}-${ARCH}-linux.tgz \
#   /tmp/ookla-speedtest.tgz

RUN apk add --no-cache --virtual deps tar curl && \
    ARCH=$(apk info --print-arch) && \
    echo ARCH=$ARCH && \
    case "$ARCH" in \
      x86) _arch=i386 ;; \
      armv7) _arch=armhf ;; \
      *) _arch="$ARCH" ;; \
    esac && \
    echo https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-${VERSION}-${_arch}-linux.tgz && \
    curl -fsSL -o /tmp/ookla-speedtest.tgz \
      https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-${VERSION}-${_arch}-linux.tgz && \
    tar xvfz /tmp/ookla-speedtest.tgz -C /usr/local/bin speedtest && \
    rm -rf /tmp/ookla-speedtest.tgz && \
    adduser -D speedtest && \
    su speedtest -c "speedtest --accept-license --accept-gdpr" && \
    apk del deps

USER speedtest

ENTRYPOINT ["/usr/local/bin/speedtest"]
