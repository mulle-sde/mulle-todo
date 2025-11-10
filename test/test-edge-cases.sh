#!/usr/bin/env bash
#
# Edge case tests for mulle-todo
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MULLE_TODO="${SCRIPT_DIR}/../mulle-todo"
TEST_TODO_FILE="/tmp/mulle-todo-test-edge-$$.txt"

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

assert_fails() {
    local message="$1"
    shift
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if "$@" >/dev/null 2>&1; then
        echo -e "${RED}✗${NC} ${message}"
        echo "  Command should have failed but succeeded"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} ${message}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
}

assert_succeeds() {
    local message="$1"
    shift
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if "$@" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} ${message}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} ${message}"
        echo "  Command should have succeeded but failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_remove_out_of_range() {
    echo "=== Test: Remove item out of range ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    
    assert_fails "Should fail when removing item 99" todo remove 99
    assert_fails "Should fail when removing item 0" todo remove 0
    
    teardown
}

test_move_up_first_item() {
    echo "=== Test: Move up first item ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    
    assert_fails "Should fail when moving item 1 up" todo up 1
    
    teardown
}

test_move_down_last_item() {
    echo "=== Test: Move down last item ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    
    assert_fails "Should fail when moving last item down" todo down 2
    
    teardown
}

test_move_out_of_range() {
    echo "=== Test: Move item out of range ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    
    assert_fails "Should fail when moving item 99 up" todo up 99
    assert_fails "Should fail when moving item 99 down" todo down 99
    
    teardown
}

test_remove_from_empty_list() {
    echo "=== Test: Remove from empty list ==="
    setup
    
    assert_fails "Should fail when removing from empty list" todo remove 1
    
    teardown
}

test_clear_empty_list() {
    echo "=== Test: Clear empty list ==="
    setup
    
    assert_succeeds "Should succeed when clearing empty list" todo clear
    
    teardown
}

test_single_item_operations() {
    echo "=== Test: Operations on single item list ==="
    setup
    
    todo add "Only task" >/dev/null 2>&1
    
    assert_fails "Should fail moving single item up" todo up 1
    assert_fails "Should fail moving single item down" todo down 1
    assert_succeeds "Should succeed removing single item" todo remove 1
    
    teardown
}

# Run all tests
echo "Running mulle-todo edge case tests..."
echo ""

test_remove_out_of_range
test_move_up_first_item
test_move_down_last_item
test_move_out_of_range
test_remove_from_empty_list
test_clear_empty_list
test_single_item_operations

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
