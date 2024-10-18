#!/bin/bash

set -euo pipefail

# Checks that julia and git are available in PATH
for cmd in julia git; do
  if ! command -v "$cmd" >/dev/null 2>&1 || ! "$cmd" --version >/dev/null 2>&1; then
    echo "::error::runic-action: $cmd is a required dependency but does not seem to be available."
    exit 1
  fi
done

# Check that the julia version is at least 1.10
if ! julia -e 'exit(VERSION < v"1.10")' >/dev/null 2>&1; then
    echo "::error::runic-action: julia version >= 1.10 is required."
    exit 1
fi

# Check that we are in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "::error::runic-action: directory is not a git repository."
    exit 1
fi
