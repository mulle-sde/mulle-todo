# mulle-todo Test Suite

Automated tests for the mulle-todo application.

## Running Tests

### Run all tests:
```bash
cd test
./run-all-tests.sh
```

### Run individual test suites:
```bash
# Basic functionality tests
./test-basic.sh

# Truncation and display limit tests
./test-truncation.sh

# Edge case tests
./test-edge-cases.sh
```

## Test Isolation

**Tests use the `--file` flag to work with temporary files**, so they won't touch your actual todo list at `~/.mulle/etc/todo/todo.txt`. Each test suite creates its own temporary file which is automatically cleaned up after the tests complete.

## Test Suites

### test-basic.sh
Tests core functionality:
- Adding items
- Removing items
- Removing all items
- Moving items up and down
- Listing items
- Empty list handling

### test-truncation.sh
Tests display limits and smart truncation:
- Display with no limit
- Display with various limits (1, 2, 3, 4+)
- Top 3 items always in order
- Random selection of remaining items
- Show command with limits
- Limit greater than total items

### test-edge-cases.sh
Tests error handling and special cases:
- Out of range operations
- Moving first/last items
- Empty list operations
- Single item operations

## Test Output

Tests use color-coded output:
- 🟢 Green checkmark (✓) = Test passed
- 🔴 Red X (✗) = Test failed

Each test suite provides a summary at the end showing:
- Total tests run
- Tests passed
- Tests failed

## Requirements

- bash
- mulle-todo script in parent directory
- mulle-bashfunctions installed

## Cleanup

Tests automatically clean up their temporary files in `/tmp/mulle-todo-test-*.txt`.

If tests are interrupted, you can manually clean up with:
```bash
rm -f /tmp/mulle-todo-test-*.txt
```

Your actual todo file at `~/.mulle/etc/todo/todo.txt` is never touched by the test suite.
