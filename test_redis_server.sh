#!/bin/bash
# test_redis_server.sh - Automated test suite for AILANG Redis server

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "==================================="
echo "AILANG Redis Server Test Suite"
echo "==================================="
echo ""

# Function to test a command and check result
test_command() {
    local description="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "Testing: $description ... "
    result=$(redis-cli -p 6379 $command 2>&1)
    
    if [[ "$result" == *"$expected"* ]]; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "  Command: $command"
        echo "  Expected: $expected"
        echo "  Got: $result"
        return 1
    fi
}

# Keep track of results
PASSED=0
FAILED=0

# Basic connectivity
test_command "PING" "PING" "PONG" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# SET commands
test_command "SET name" "SET name AILANG" "OK" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "SET version" "SET version 2.0" "OK" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "SET author" "SET author Sean" "OK" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# GET commands
test_command "GET name" "GET name" "AILANG" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "GET version" "GET version" "2.0" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "GET author" "GET author" "Sean" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "GET nonexistent" "GET nonexistent" "(nil)" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# EXISTS commands
test_command "EXISTS name" "EXISTS name" "(integer) 1" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "EXISTS nonexistent" "EXISTS nonexistent" "(integer) 0" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# INCR/DECR if implemented
test_command "SET counter" "SET counter 0" "OK" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "INCR counter" "INCR counter" "(integer) 1" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "INCR counter" "INCR counter" "(integer) 2" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "DECR counter" "DECR counter" "(integer) 1" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# APPEND/STRLEN if implemented
test_command "SET msg" "SET msg Hello" "OK" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "APPEND msg" "APPEND msg World" "(integer)" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "STRLEN msg" "STRLEN msg" "(integer)" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# DEL command
test_command "DEL msg" "DEL msg" "(integer) 1" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))
test_command "EXISTS after DEL" "EXISTS msg" "(integer) 0" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

# ECHO if implemented
test_command "ECHO" "ECHO test" "test" && PASSED=$((PASSED+1)) || FAILED=$((FAILED+1))

echo ""
echo "==================================="
echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
echo "==================================="

exit $FAILED