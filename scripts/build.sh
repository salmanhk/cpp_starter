#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")
BUILD_DIR="$PROJECT_ROOT/build"
if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
fi
cmake --build "$BUILD_DIR" --config Release
