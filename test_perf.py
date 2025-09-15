#!/usr/bin/env python3
# test_perf.py - Direct socket performance test
import socket
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('localhost', 6379))

# Single PING test
ping_cmd = b'*1\r\n$4\r\nPING\r\n'

# Warm up
sock.send(ping_cmd)
sock.recv(1024)

# Time 100 PINGs
start = time.time()
for i in range(100):
    sock.send(ping_cmd)
    response = sock.recv(1024)
    if response != b'+PONG\r\n':
        print(f"Bad response: {response}")
        break
end = time.time()

elapsed = end - start
print(f"100 PINGs: {elapsed*1000:.2f}ms total")
print(f"Average: {elapsed*10:.2f}ms per PING")

sock.close()