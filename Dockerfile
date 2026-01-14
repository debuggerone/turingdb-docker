# ============================================================
# TuringDB – Unofficial Docker Image
# Ubuntu 22.04
# Uses upstream dependencies.sh + setup.sh semantics
#
# Image tag:
#   debuggerone:turingdb-ubuntu2204-cpu
# ============================================================

# ----------------------------
# Builder stage (NAME MATTERS)
# ----------------------------
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_BUILD_TYPE=Release

# ------------------------------------------------------------
# Base build deps + sudo (required by dependencies.sh)
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc-11 g++-11 \
    cmake \
    git \
    curl \
    sudo \
    ca-certificates \
    bison \
    flex \
    libssl-dev \
    libcurl4-openssl-dev \
    libopenblas-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Build user
# ------------------------------------------------------------
RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

# ------------------------------------------------------------
# Clone repo WITH submodules
# ------------------------------------------------------------
RUN git clone --recursive https://github.com/turing-db/turingdb.git
WORKDIR /home/builder/turingdb

# ------------------------------------------------------------
# Build vendored dependencies
# ------------------------------------------------------------
RUN ./dependencies.sh

# ------------------------------------------------------------
# Build & install TuringDB (into build/turing_install)
# ------------------------------------------------------------
RUN mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install

# ----------------------------
# Runtime stage
# ----------------------------
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Runtime libs only
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libcurl4 \
    libopenblas0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m turingdb
WORKDIR /data

# 👇 THIS NOW WORKS
COPY --from=builder \
  /home/builder/turingdb/build/turing_install/bin/turingdb \
  /usr/local/bin/turingdb

EXPOSE 6666
USER turingdb

ENTRYPOINT ["turingdb"]
