

A Redis-compatible server implementation in AILANG, demonstrating real-world systems programming capabilities of the AILANG language.
---
## Features

- Full RESP (Redis Serialization Protocol) implementation
- 15+ Redis commands supported
- Native compilation to x86-64
- Zero runtime dependencies
- Memory-safe operations with explicit control

## Performance

- **Response Time**: 0.08ms per request (80μs)
- **Throughput**: ~12,500 requests/second
- **Binary Size**: 37KB compiled
- **Memory Usage**: Minimal, no GC overhead

## Code Statistics

- **460 lines** - Server implementation (`redis_server.ailang`)
- **648 lines** - RESP protocol library (`Library.RESP.ailang`)
- **1,108 lines** - Total AILANG code
- **37KB** - Final executable size

Compare to Redis (140K+ lines of C) or typical Node.js implementations (5K+ lines).

## Supported Commands

- **Basic**: PING, ECHO, QUIT
- **Strings**: SET, GET, APPEND, STRLEN
- **Keys**: EXISTS, DEL
- **Counters**: INCR, DECR
- **Server**: INFO, COMMAND, SELECT, FLUSHDB, DBSIZE
- **Config**: CONFIG GET/SET

## Building

Requires AILANG compiler:
```bash
# Compile the server
python3 main.py redis_server.ailang

# Run the server
./redis_server_exec
Testing
bash# Test with redis-cli
redis-cli -p 6379 PING

# Run test suite
./test_ailang_redis.sh

# Performance test
python3 test_perf.py
Project Structure
├── redis_server.ailang       # Main server implementation
├── Library.RESP.ailang        # RESP protocol library
├── test_ailang_redis.sh       # Protocol compliance tests
├── test_perf.py              # Performance benchmark
└── README.md                 # This file
Implementation Details
The server uses:

Direct socket programming for network I/O
Hash tables for key-value storage
RESP protocol for Redis compatibility
Manual memory management with explicit allocation/deallocation

AILANG Language
AILANG is a minimalist systems programming language that compiles directly to x86-64 assembly. Key features:

No runtime or garbage collector
Explicit memory management
Named operations (no operator overloading)
Direct hardware control
Tiny binary output

Learn more about AILANG: [link to AILANG repo]
Benchmarks
Tested on WSL2/Ubuntu on Windows 10:
CommandTimeComparisonPING0.08msRedis: ~0.05msSET0.09msRedis: ~0.06msGET0.08msRedis: ~0.05ms
Native Linux performance expected to be 30-50% faster
Why This Matters
This project demonstrates that:

Minimalist languages can build real infrastructure
Explicit control doesn't require verbosity
Small, efficient binaries are achievable
Systems programming is accessible

License
 MIT
Author
Sean
Acknowledgments
Built with AILANG - proving that less is more in systems programming.
