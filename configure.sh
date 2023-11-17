#!/bin/bash

cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=/workspaces/vcpkg/scripts/buildsystems/vcpkg.cmake
