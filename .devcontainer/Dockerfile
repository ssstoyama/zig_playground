ARG zigv="zig-linux-x86_64-0.11.0-dev.2613+b42562be7"

# Build
FROM debian:bullseye AS builder

ARG zigv

WORKDIR /tmp
RUN apt update && apt install -y \
  curl \
  xz-utils

RUN curl https://ziglang.org/builds/${zigv}.tar.xz \
  | tar -Jxvf -

# Package
FROM alpine:latest AS target

ARG zigv

RUN apk add  --no-cache \
    git

COPY --from=builder /tmp/${zigv} /usr/local/bin/${zigv}
RUN ln -s /usr/local/bin/${zigv}/zig /usr/local/bin/zig

WORKDIR /home
