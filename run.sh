#!/bin/bash
set -e

BUILD_DIR="build"

if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
fi

cd "$BUILD_DIR"

if [ "$1" = "release" ]; then
    cmake .. -DRELEASE=ON
else
    cmake .. -DRELEASE=OFF
fi

make
cd ..
./build/c-asm-learn
