#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
BUILD_DIR="$SCRIPT_DIR/../build"

echo "Build directory: $BUILD_DIR"
echo "Are you sure you want to delete non-vcpkg contents in the build directory? (y/n)"
read -p "> " confirmation

if [[ $confirmation =~ ^[Yy]$ ]]; then
    find "$BUILD_DIR" -mindepth 1 -not -name 'vcpkg_installed' -not -name 'vcpkg-manifest-install.log' -not -path '*/vcpkg_installed/*' -exec rm -rv {} + 2>/dev/null
    echo "Non-vcpkg related artifacts in the build directory has been deleted."
else
    echo "Deletion canceled."
fi