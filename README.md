# TuringDB – Unofficial Docker Image

⚠️ **Unofficial Docker Release**  
This Docker image is **not an official release** of TuringDB.  
It is maintained independently by a community member and is **not affiliated with, endorsed by, or maintained by the TuringDB team**.

I know members of the team personally, but **I am not employed by TuringDB**, and this image is provided **as-is** for convenience and experimentation.

---

## What is TuringDB?

TuringDB is a **blazingly fast, in-memory, column-oriented graph database engine** built in C++ for analytical and read-intensive workloads.

It is designed to deliver:
- **millisecond-level query latency**
- **zero-lock reads**
- **snapshot isolation**
- **git-like versioning for graphs**

This Docker image focuses on **maximum runtime performance** with a **minimal footprint**.

---

## About This Image

**Goals**
- Minimal runtime image (no build tools)
- Optimized Release build (`-O3`)
- Suitable for large in-memory graphs
- Clean signal handling
- Ready for production-like environments

**What this image is**
- A convenience wrapper around the official TuringDB source
- Built from the public GitHub repository
- Suitable for testing, benchmarking, demos, and internal tools

**What this image is NOT**
- An official distribution
- A supported enterprise artifact
- A replacement for official installation methods

---

## Quick Start

```bash
docker run -d \
  --name turingdb \
  -p 6666:6666 \
  --ulimit memlock=-1 \
  --shm-size=4g \
  turingdb/turingdb:latest
```

TuringDB will start immediately and expose its REST API on:

```
http://localhost:6666
```

---

## Performance Recommendations (Important)

For best performance on large graphs:

### Disable swapping
```bash
--ulimit memlock=-1
```

### Increase shared memory
```bash
--shm-size=4g   # or higher
```

### Optional CPU pinning
```bash
--cpuset-cpus="0-7"
```

### Optional Huge Pages (host-side)
```bash
echo 4096 | sudo tee /proc/sys/vm/nr_hugepages
```

---

## Ports

| Port | Description |
|-----:|-------------|
| 6666 | REST API |

---

## Data Persistence

By default, the container runs with `/data` as its working directory.

Recommended:
```bash
-v $(pwd)/data:/data
```

---

## License

TuringDB Community Edition is licensed under the **Business Source License (BSL)**.

This Docker image:
- Does **not** modify the license
- Does **not** claim open-source status
- Simply redistributes unmodified binaries built from upstream source

See the upstream `LICENSE` file for details.

---

## Disclaimer

This is an **unofficial community build**.

- No guarantees
- No SLAs
- No official support

If you need production support, compliance guarantees, or enterprise features, **contact the TuringDB team directly**.

---

## Source & Transparency

- Upstream source: https://github.com/turing-db/turingdb
- Dockerfile: built via multi-stage build, runtime-only image
- No telemetry, no added code

---

## Why This Exists

Because sometimes you just want to run:

```bash
docker run turingdb/turingdb
```

…and immediately start querying massive graphs at ridiculous speed.

---

⭐ If you like TuringDB, please star the official GitHub repository and support the core team.
