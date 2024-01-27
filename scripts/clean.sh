#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
BUILD_DIR="$SCRIPT_DIR/../build"

echo "Build directory to be deleted: $BUILD_DIR"
echo "Are you sure you want to delete all contents in the build directory? (y/n)"
read -p "> " confirmation

if [[ $confirmation =~ ^[Yy]$ ]]; then
    rm -rf "$BUILD_DIR"
    echo "The build directory has been deleted."
else
    echo "Deletion canceled."
fi
