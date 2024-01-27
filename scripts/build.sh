#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")
BUILD_DIR="$PROJECT_ROOT/build"
mkdir "$BUILD_DIR"
cmake --build "$BUILD_DIR" --config Release
