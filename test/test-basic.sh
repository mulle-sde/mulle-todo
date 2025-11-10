#!/usr/bin/env bash
#
# Basic functionality tests for mulle-todo
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MULLE_TODO="${SCRIPT_DIR}/../mulle-todo"
TEST_TODO_FILE="/tmp/mulle-todo-test-$$.txt"

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

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "${expected}" = "${actual}" ]; then
        echo -e "${GREEN}✓${NC} ${message}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} ${message}"
        echo "  Expected: ${expected}"
        echo "  Got:      ${actual}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
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
        echo "  In: ${haystack}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_add_item() {
    echo "=== Test: Add single item ==="
    setup
    
    todo add "Test task 1" >/dev/null 2>&1
    local output=$(todo list 2>&1)
    
    assert_contains "${output}" "Test task 1" "Should contain added task"
    assert_contains "${output}" "1." "Should have item number"
    
    teardown
}

test_add_multiple_items() {
    echo "=== Test: Add multiple items ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    todo add "Task 3" >/dev/null 2>&1
    
    local output=$(todo list 2>&1)
    
    assert_contains "${output}" "Task 1" "Should contain task 1"
    assert_contains "${output}" "Task 2" "Should contain task 2"
    assert_contains "${output}" "Task 3" "Should contain task 3"
    
    teardown
}

test_empty_list() {
    echo "=== Test: Empty list ==="
    setup
    
    local output=$(todo list 2>&1)
    
    assert_contains "${output}" "No todos yet" "Should show empty message"
    
    teardown
}

test_remove_item() {
    echo "=== Test: Remove item ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    todo add "Task 3" >/dev/null 2>&1
    
    todo remove 2 >/dev/null 2>&1
    
    local output=$(todo list 2>&1)
    
    assert_contains "${output}" "Task 1" "Should still have task 1"
    assert_contains "${output}" "Task 3" "Should still have task 3"
    
    if [[ "${output}" == *"Task 2"* ]]; then
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} Should not contain removed task 2"
    else
        TESTS_RUN=$((TESTS_RUN + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} Should not contain removed task 2"
    fi
    
    teardown
}

test_remove_all() {
    echo "=== Test: Remove all items ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    
    todo remove-all >/dev/null 2>&1
    
    local output=$(todo list 2>&1)
    
    assert_contains "${output}" "No todos yet" "Should show empty message after clear"
    
    teardown
}

test_move_up() {
    echo "=== Test: Move item up ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    todo add "Task 3" >/dev/null 2>&1
    
    todo up 3 >/dev/null 2>&1
    
    local output=$(todo list 2>&1)
    local line2=$(echo "${output}" | grep "2\.")
    
    assert_contains "${line2}" "Task 3" "Task 3 should be at position 2"
    
    teardown
}

test_move_down() {
    echo "=== Test: Move item down ==="
    setup
    
    todo add "Task 1" >/dev/null 2>&1
    todo add "Task 2" >/dev/null 2>&1
    todo add "Task 3" >/dev/null 2>&1
    
    todo down 1 >/dev/null 2>&1
    
    local output=$(todo list 2>&1)
    local line2=$(echo "${output}" | grep "2\.")
    
    assert_contains "${line2}" "Task 1" "Task 1 should be at position 2"
    
    teardown
}

# Run all tests
echo "Running mulle-todo basic tests..."
echo ""

test_empty_list
test_add_item
test_add_multiple_items
test_remove_item
test_remove_all
test_move_up
test_move_down

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
