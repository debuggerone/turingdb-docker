# TuringDB – Unofficial Docker Image

⚠️ **Unofficial Docker Release**

This Docker image is **not an official release** of TuringDB.  
It is maintained independently by a community member and is **not affiliated with, endorsed by, or maintained by the TuringDB team**.

I am personally familiar with members of the TuringDB team, but **I am not employed by them**.  
This image is provided **as-is**, for convenience, testing, and experimentation.

---

## What is TuringDB?

TuringDB is a **high-performance, in-memory, column-oriented graph database engine** written in C++, designed for analytical and read-intensive workloads.

Core characteristics:

- **Millisecond-level query latency**
- **Zero-lock reads**
- **Snapshot isolation**
- **Git-like versioning for graphs**

This Docker image focuses on running TuringDB **unchanged**, exactly as upstream provides it, inside a container.

---

## About This Image

### Goals
- Minimal runtime image (no build tools included)
- Optimized Release build
- Suitable for large in-memory graphs
- Transparent, reproducible behavior
- No changes to upstream code or runtime semantics

### What this image is
- A thin Docker wrapper around the official TuringDB source
- Built from the public upstream repository
- Intended for testing, benchmarking, demos, and local development

### What this image is NOT
- An official TuringDB distribution
- A supported enterprise artifact
- A replacement for official installation methods

---

## Quick Start

### 1. Prepare a data directory

TuringDB requires a writable directory for its internal state.

```bash
mkdir -p turing-data
sudo chown -R "$(id -u)":"$(id -g)" turing-data
```

---

### 2. Run TuringDB in Docker

```bash
docker run -it --name turingdb-test \
  -p 6666:6666 \
  --ulimit memlock=-1 \
  --shm-size=2g \
  -v "$(pwd)/turing-data:/data" \
  --entrypoint /usr/local/bin/turingdb \
  debuggerone:turingdb-ubuntu2204-cpu \
  -p 6666 -i 0.0.0.0 -turing-dir /data
```

TuringDB will start in the foreground and expose its REST API on:

```
http://localhost:6666
```

---

## Notes on Runtime Behavior

- TuringDB runs **in the foreground** inside the container
- No daemon mode is used (daemon mode is not container-friendly)
- The server binds explicitly to `0.0.0.0` to allow Docker port forwarding
- Data persistence is controlled entirely via the mounted `/data` directory

---

## License

This repository (Dockerfile and related files) is licensed under the **MIT License**.

TuringDB Community Edition itself is licensed under the **Business Source License (BSL)**.

This Docker image:
- Does **not** modify the upstream license
- Does **not** claim open-source status for TuringDB
- Simply redistributes binaries built from upstream source

See the upstream `LICENSE` file for details.

---

## Disclaimer

This is an **unofficial community build**.

- No guarantees
- No SLAs
- No official support

For production support, compliance requirements, or enterprise features, please contact the TuringDB team directly.

---

## Source & Transparency

- Upstream source: https://github.com/turing-db/turingdb
- Dockerfile: multi-stage build, runtime-only image
- No telemetry
- No additional patches or behavioral changes

---

## Why This Exists

Because sometimes you just want to:

```bash
docker run -it -p 6666:6666 debuggerone:turingdb-ubuntu2204-cpu
```

…and start working with a very fast graph database, without setting up a full native build environment.

⭐ If you like TuringDB, please support the project by starring the official GitHub repository.
