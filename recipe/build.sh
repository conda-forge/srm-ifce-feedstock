#!/usr/bin/env bash
set -euo pipefail

mkdir build
cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DLIB_SUFFIX="" \
    -DGSOAP_WSDL2H=$BUILD_PREFIX/bin/wsdl2h \
    -DGSOAP_SOAPCPP2=$BUILD_PREFIX/bin/soapcpp2 \
    ..

make -j${CPU_COUNT}
patch -p1 < "${RECIPE_DIR}/0001-Fix-srm2__TPermissionMode.patch"
make -j${CPU_COUNT}
make install
