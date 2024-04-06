#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT_DIR/build"
VCPKG_TOOLCHAIN_FILE="/vcpkg/scripts/buildsystems/vcpkg.cmake"

cmake -S "$PROJECT_ROOT_DIR" -B "$BUILD_DIR" \
      -G Ninja \
      -DCMAKE_TOOLCHAIN_FILE="$VCPKG_TOOLCHAIN_FILE" \
      -DCMAKE_POLICY_DEFAULT_CMP0025=NEW
