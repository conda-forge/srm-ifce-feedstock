#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

mkdir build
cd build

declare -a CMAKE_PLATFORM_FLAGS
if [ "$(uname)" == "Linux" ]; then
    # Fix up CMake for using conda's sysroot
    # See https://docs.conda.io/projects/conda-build/en/latest/resources/compiler-tools.html?highlight=cmake#an-aside-on-cmake-and-sysroots
    CMAKE_PLATFORM_FLAGS+=("-DCMAKE_TOOLCHAIN_FILE=${RECIPE_DIR}/cross-linux.cmake")
else
    CMAKE_PLATFORM_FLAGS+=("-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}")
    CMAKE_PLATFORM_FLAGS+=("-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}")
fi

cmake ${CMAKE_ARGS} -LAH \
    "${CMAKE_PLATFORM_FLAGS[@]}" \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DLIB_SUFFIX="" \
    ..

make -j${CPU_COUNT}
patch -p1 < "${RECIPE_DIR}/0001-Fix-srm2__TPermissionMode.patch"
make -j${CPU_COUNT}
make install
