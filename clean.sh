#!/bin/bash

echo "Are you sure you want to delete all contents in the build directory? (y/n)"
read -p "> " confirmation

if [[ $confirmation =~ ^[Yy]$ ]]; then
    rm -rf build
    echo "The build directory has been deleted."
else
    echo "Deletion canceled."
fi
