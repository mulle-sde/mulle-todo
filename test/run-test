#!/usr/bin/env bash
#
# Run all mulle-todo tests
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  mulle-todo Test Suite${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

TOTAL_FAILED=0

# Run basic tests
echo -e "${BLUE}▶ Running basic functionality tests...${NC}"
echo ""
if bash "${SCRIPT_DIR}/test-basic.sh"; then
    echo ""
else
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    echo ""
fi

# Run truncation tests
echo -e "${BLUE}▶ Running truncation tests...${NC}"
echo ""
if bash "${SCRIPT_DIR}/test-truncation.sh"; then
    echo ""
else
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    echo ""
fi

# Run edge case tests
echo -e "${BLUE}▶ Running edge case tests...${NC}"
echo ""
if bash "${SCRIPT_DIR}/test-edge-cases.sh"; then
    echo ""
else
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    echo ""
fi

# Final summary
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Test Suite Summary${NC}"
echo -e "${BLUE}================================${NC}"

if [ ${TOTAL_FAILED} -eq 0 ]; then
    echo -e "${GREEN}✓ All test suites passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ ${TOTAL_FAILED} test suite(s) failed${NC}"
    exit 1
fi
