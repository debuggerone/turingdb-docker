# =========================
# Build Stage
# =========================
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_BUILD_TYPE=Release

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc-11 g++-11 \
    cmake \
    git \
    curl \
    ca-certificates \
    bison \
    flex \
    libssl-dev \
    libcurl4-openssl-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone inkl. Submodules
RUN git clone --recursive https://github.com/turing-db/turingdb.git
WORKDIR /build/turingdb

# Dependencies-Script (falls benötigt)
RUN ./dependencies.sh

# Build
RUN mkdir -p build && cd build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_FLAGS="-O3 -march=native -DNDEBUG" && \
    make -j$(nproc) && \
    make install

# =========================
# Runtime Stage (minimal)
# =========================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Nur Runtime-Abhängigkeiten
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libcurl4 \
    libopenblas0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Optional: Non-root User (empfohlen für Prod)
RUN useradd -m turingdb

WORKDIR /data

# Binary übernehmen
COPY --from=builder /usr/local/bin/turingdb /usr/local/bin/turingdb

# Ports
EXPOSE 6666

USER turingdb

# Sauberes Signal-Handling
ENTRYPOINT ["turingdb"]
