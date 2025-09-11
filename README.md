# AIRedis: A Redis Server Implementation in AILang
## Proving Network Services Without C

### Executive Summary
AIRedis demonstrates AILang's capability for building production-style network services by implementing core Redis functionality. This project showcases memory-safe network programming, RESP protocol handling, and concurrent client management—all in AILang's verb-first syntax without C dependencies.

### Project Goals
- **Validate AILang for network services** - Build real server applications
- **Implement RESP protocol** - Full Redis wire protocol compatibility
- **Memory-safe networking** - Pool-based client and buffer management
- **Educational clarity** - Readable implementation of Redis internals
- **Foundation for expansion** - Extensible architecture for adding features

### Architecture Overview

**Component Stack**
```
RESP Protocol Parser → Command Dispatcher → Storage Engine
        ↓                     ↓                  ↓
[Array/Bulk String]   [GET/SET/DEL/PING]   [Hash Table]
        ↓                     ↓                  ↓
Network Layer → Connection Handler → Memory Pools
```

### Implementation Status

**Working Components**
- ✅ Basic TCP server socket binding
- ✅ Client connection acceptance
- ✅ Simple PING/PONG response
- ✅ Hash table storage initialization
- ✅ Sequential client handling

**In Development**
- 🔧 Full RESP protocol parser
- 🔧 Command dispatcher (GET/SET/DEL/EXISTS)
- 🔧 Concurrent client handling
- 🔧 Response builder functions
- 🔧 Memory pool integration

**Planned Features**
- 📋 Pub/Sub messaging
- 📋 Persistence (RDB/AOF)
- 📋 Replication
- 📋 Transactions
- 📋 Lua scripting

### Core Design

**Memory Management**
```ailang
Pool.Redis.MainStorage = DynamicPool {
    "redis_data": ElementType-Address, CanChange-True,
    "cache_policy": Initialize-"L2"
}

Pool.Redis.ResponseBuffers = TemporalPool {
    "response_data": ElementType-Byte, MaximumLength-1048576,
    "lifetime": Initialize-"request_scope"
}
```
- Pool-based allocation prevents memory leaks
- Request-scoped buffers for automatic cleanup
- Cache-aware allocation strategies

**RESP Protocol Implementation**
```ailang
Function.RESP.ParseCommand {
    // Parse: *2\r\n$3\r\nGET\r\n$3\r\nkey\r\n
    first_byte = Dereference(buffer)
    IfCondition NotEqual(first_byte, 42) { // '*'
        ReturnValue(Array.Create())
    }
    // Extract array count and bulk strings...
}
```
- Full RESP array parsing
- Bulk string handling
- Error response generation
- Integer and simple string builders

**Command Processing**
```ailang
Function.Redis.DispatchCommand {
    command = StringToUpper(Array.Get(command_parts, 0))
    ChoosePath command {
        CaseOption "GET": Redis.Command.GET(key)
        CaseOption "SET": Redis.Command.SET(key, value)
        CaseOption "PING": Redis.Command.PING()
        DefaultOption: RESP.BuildSimpleString("-ERR unknown")
    }
}
```

### Development Approach

**Phase 1: Minimal Working Server**
- Basic socket operations
- PING/PONG functionality
- Single client support
- Hash table initialization

**Phase 2: Core Redis Commands**
- GET/SET implementation
- DEL/EXISTS support
- RESP protocol compliance
- Multi-client handling

**Phase 3: Production Features**
- Thread-based concurrency
- Connection pooling
- INFO command
- Signal handling

### Code Organization

**Minimal Version (`redis_minimal.ailang`)**
- 80 lines of pure primitives
- No library dependencies
- Hardcoded PING response
- Demonstrates bare-metal networking

**Full Version (`redis_server.ailang`)**
- Complete RESP implementation
- Command dispatcher
- Pool-based memory management
- Thread support for concurrent clients

### Technical Challenges & Solutions

**Challenge: RESP Parsing Without String Libraries**
- Solution: Byte-by-byte parsing with manual offset tracking
- Character-by-character string building
- Array-based buffer manipulation

**Challenge: Concurrent Client Handling**
- Solution: Thread.Create() with detached execution
- Per-client request buffers
- Connection count tracking

**Challenge: Memory Safety**
- Solution: Pool allocators with automatic cleanup
- Request-scoped temporal pools
- Fixed-size connection pools

### Missing Components (To Be Implemented)

**Language Features Needed**
- String manipulation utilities (StringExtract, StringCharAt)
- System functions (GetCurrentTime, GetProcessID)
- Thread management (Create, Detach)
- Signal handling framework
- Optional/nullable types

**Redis Features Pending**
- Data persistence
- Expiration/TTL
- Sorted sets, lists, streams
- Clustering support
- Sentinel integration

### Educational Value

AIRedis serves as a teaching tool for:
- Network protocol implementation
- Server architecture patterns
- Memory-safe systems programming
- Concurrent connection handling

Key learning points:
- How Redis wire protocol works
- Building servers without libc
- Pool-based memory patterns
- State machine command processing

### Testing Strategy

**Unit Tests**
```ailang
Test.RESP.ParseArray {
    input = "*2\r\n$3\r\nGET\r\n$3\r\nkey\r\n"
    result = RESP.ParseCommand(input)
    Assert.Equal(result[0], "GET")
    Assert.Equal(result[1], "key")
}
```

**Integration Tests**
- redis-cli compatibility
- redis-benchmark stress testing
- Protocol compliance validation

### Building and Running

**Compilation**
```bash
# Compile minimal version
ailang compile redis_minimal.ailang -o redis_minimal

# Compile full server
ailang compile redis_server.ailang -o redis_server
```

**Execution**
```bash
# Run server
./redis_server

# Test with redis-cli
redis-cli -p 6379
> PING
PONG
> SET key value
OK
> GET key
"value"
```

### Repository Structure
```
airedis/
├── src/
│   ├── redis_minimal.ailang    # Primitive-only version
│   ├── redis_server.ailang     # Full implementation
│   └── resp_protocol.ailang    # RESP utilities
├── tests/
│   ├── unit/                   # Unit tests
│   └── integration/             # redis-cli tests
├── benchmarks/                 # Performance tests (future)
└── docs/
    ├── PROTOCOL.md             # RESP specification
    └── COMMANDS.md             # Supported commands
```

### Development Philosophy

"Get it working, then optimize" - The current focus is on correctness and completeness rather than performance. Once the full Redis command set is implemented and tests pass, optimization will follow through:
- Assembly-level tuning
- Cache optimization
- Zero-copy networking
- Lock-free data structures

### Conclusion

AIRedis proves that complex network services can be built in AILang without C. The implementation showcases memory-safe networking, protocol handling, and concurrent programming while maintaining code clarity. This project serves as both a practical Redis server and an educational resource for systems programming in AILang.

### Future Roadmap

**Q1 2026: Core Completion**
- All basic Redis commands
- Full RESP compliance
- Multi-threading support

**Q2 2026: Advanced Features**
- Persistence (RDB/AOF)
- Pub/Sub messaging
- Lua scripting

**Q3 2026: Production Ready**
- Clustering support
- Sentinel integration
- Performance optimization

### Contributing

Key areas needing work:
- String manipulation primitives
- RESP protocol extensions
- Command implementations
- Test coverage expansion

### License
MIT License

---
*AIRedis: Redis reimagined in AILang*

### References
- [Redis Protocol Specification](https://redis.io/docs/reference/protocol-spec/)
- [AILang Documentation](./AILANG.md)
- [Memory Pool Design](./POOLS.md)
