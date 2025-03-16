ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rnb
ADD . /rnb

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl libjemalloc2 libvips libpq-dev ffmpeg && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENTRYPOINT [ "./bin/docker_entrypoint.sh" ]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    BUNDLE_JOBS=2 \
    GEM_HOME=/bundle \
    BUNDLE_GEMFILE=/rnb/Gemfile

ENV PATH="${BUNDLE_BIN}:${PATH}"
