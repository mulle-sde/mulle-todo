#!/usr/bin/env bash
#
# Truncation and display limit tests for mulle-todo
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MULLE_TODO="${SCRIPT_DIR}/../mulle-todo"
TEST_TODO_FILE="/tmp/mulle-todo-test-trunc-$$.txt"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

setup() {
    rm -f "${TEST_TODO_FILE}"
}

teardown() {
    rm -f "${TEST_TODO_FILE}"
}

# Helper to run mulle-todo with test file
todo() {
    "${MULLE_TODO}" --file "${TEST_TODO_FILE}" "$@"
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "${haystack}" == *"${needle}"* ]]; then
        echo -e "${GREEN}✓${NC} ${message}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} ${message}"
        echo "  Expected to find: ${needle}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_line_count() {
    local output="$1"
    local expected="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    # Strip ANSI color codes before counting
    local clean_output=$(echo "${output}" | sed 's/\x1b\[[0-9;]*m//g')
    # Match lines with ▸ or just plain numbered items
    local actual=$(echo "${clean_output}" | grep -E "(▸.*[0-9]\.|^[[:space:]]*[0-9]+\.)" | wc -l)
    
    if [ "${expected}" -eq "${actual}" ]; then
        echo -e "${GREEN}✓${NC} ${message} (expected ${expected}, got ${actual})"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} ${message}"
        echo "  Expected ${expected} lines, got ${actual}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_no_limit() {
    echo "=== Test: Display all items with no limit ==="
    setup
    
    for i in {1..10}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 2>&1)
    
    assert_line_count "${output}" 10 "Should show all 10 items"
    assert_contains "${output}" "Task 1" "Should contain task 1"
    assert_contains "${output}" "Task 10" "Should contain task 10"
    
    teardown
}

test_limit_greater_than_total() {
    echo "=== Test: Limit greater than total items ==="
    setup
    
    for i in {1..5}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 100 2>&1)
    
    assert_line_count "${output}" 5 "Should show all 5 items when limit > total"
    
    teardown
}

test_limit_1() {
    echo "=== Test: Limit of 1 ==="
    setup
    
    for i in {1..5}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 1 2>&1)
    
    assert_line_count "${output}" 1 "Should show exactly 1 item"
    assert_contains "${output}" "showing 1 of 5 items" "Should indicate truncation"
    
    teardown
}

test_limit_2() {
    echo "=== Test: Limit of 2 ==="
    setup
    
    for i in {1..5}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 2 2>&1)
    
    assert_line_count "${output}" 2 "Should show exactly 2 items"
    assert_contains "${output}" "showing 2 of 5 items" "Should indicate truncation"
    
    teardown
}

test_limit_3() {
    echo "=== Test: Limit of 3 (boundary) ==="
    setup
    
    for i in {1..5}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 3 2>&1)
    
    assert_line_count "${output}" 3 "Should show exactly 3 items"
    assert_contains "${output}" "showing 3 of 5 items" "Should indicate truncation"
    
    teardown
}

test_limit_with_random() {
    echo "=== Test: Limit > 3 with random selection ==="
    setup
    
    for i in {1..10}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo list 6 2>&1)
    
    assert_line_count "${output}" 6 "Should show exactly 6 items"
    assert_contains "${output}" "Task 1" "Should always contain task 1 (top 3)"
    assert_contains "${output}" "Task 2" "Should always contain task 2 (top 3)"
    assert_contains "${output}" "Task 3" "Should always contain task 3 (top 3)"
    assert_contains "${output}" "showing 6 of 10 items (top 3 + random 3)" "Should indicate smart truncation"
    
    teardown
}

test_show_with_limit() {
    echo "=== Test: Show command with limit ==="
    setup
    
    for i in {1..8}; do
        todo add "Task ${i}" >/dev/null 2>&1
    done
    
    local output=$(todo show 5 2>&1)
    
    assert_line_count "${output}" 5 "Should show exactly 5 items in show mode"
    assert_contains "${output}" "TODO" "Should have header"
    assert_contains "${output}" "┏" "Should have decorative box border (heavy style)"
    
    teardown
}

# Run all tests
echo "Running mulle-todo truncation tests..."
echo ""

test_no_limit
test_limit_greater_than_total
test_limit_1
test_limit_2
test_limit_3
test_limit_with_random
test_show_with_limit

echo ""
echo "========================================"
echo "Tests run:    ${TESTS_RUN}"
echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
if [ ${TESTS_FAILED} -gt 0 ]; then
    echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}"
    exit 1
else
    echo -e "Tests failed: ${TESTS_FAILED}"
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
