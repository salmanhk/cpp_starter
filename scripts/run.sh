#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONSOLE_EXECUTABLE="$PROJECT_ROOT_DIR/build/src/console"
"$CONSOLE_EXECUTABLE"
