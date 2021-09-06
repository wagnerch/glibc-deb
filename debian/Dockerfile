FROM arm32v7/debian:bullseye
ENV DEBIAN_FRONTEND noninteractive

# Install developer tools
RUN apt-get update \
 && apt-get install --no-install-recommends -yV \
    build-essential \
    devscripts \
    equivs

# Install the build deps for _this_ package
COPY control /tmp/control
RUN mk-build-deps -irt 'apt-get --no-install-recommends -yV' /tmp/control \
 && rm /tmp/control

ENV DEB_BUILD_OPTIONS nocheck
