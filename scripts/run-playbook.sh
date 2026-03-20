#!/bin/bash
# scripts/run-playbook.sh
# Wrapper script for running Ansible playbooks with common options

set -e

PLAYBOOK=${1:-playbooks/provision-servers.yml}
INVENTORY=${2:-inventory/hosts.yml}
LIMIT=${3:-""}
EXTRA_ARGS=${4:-""}

if [ ! -f "$PLAYBOOK" ]; then
    echo "ERROR: Playbook not found: $PLAYBOOK"
    echo "Usage: ./scripts/run-playbook.sh <playbook> [inventory] [limit] [extra-args]"
    exit 1
fi

echo "======================================"
echo "Running Ansible Playbook"
echo "Playbook:  $PLAYBOOK"
echo "Inventory: $INVENTORY"
echo "Limit:     ${LIMIT:-all hosts}"
echo "======================================"

# Build the command
CMD="ansible-playbook -i $INVENTORY $PLAYBOOK"

# Add limit if specified
if [ -n "$LIMIT" ]; then
    CMD="$CMD --limit $LIMIT"
fi

# Add extra args if specified
if [ -n "$EXTRA_ARGS" ]; then
    CMD="$CMD $EXTRA_ARGS"
fi

echo "Executing: $CMD"
echo ""

# Run with timing
START=$(date +%s)
eval $CMD
END=$(date +%s)

echo ""
echo "======================================"
echo "Playbook completed in $((END - START)) seconds"
echo "======================================"
