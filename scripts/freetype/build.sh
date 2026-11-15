#!/bin/sh

set -e # exit immediately if a command exits with a non-zero status
set -u # treat unset variables as an error

cd ${SRC_DIR}

# libpng 1.6.40, which freetype's wrap brings, includes <fp.h>, a header of
# classic Mac OS, wherever TARGET_OS_MAC is defined. Xcode 16's clang defines
# it by itself ("pngpriv.h:524:16: fatal error: 'fp.h' file not found");
# later libpng dropped the test. The wrap is fetched first, to drop it here.
meson subprojects download libpng
for PNGPRIV in subprojects/libpng-*/pngpriv.h; do
    sed -i '' 's/ || defined(TARGET_OS_MAC)//' "${PNGPRIV}"
    if grep -q TARGET_OS_MAC "${PNGPRIV}"; then
        echo "error: TARGET_OS_MAC is still tested in ${PNGPRIV}"
        exit 1
    fi
done

meson setup build \
    --cross-file ${PROJECT_DIR}/cross-files/${OS}-${ARCH}.ini \
    --prefix="${OUTPUT_DIR}" \
    -Dbrotli=disabled \
    -Dbzip2=disabled \
    -Dharfbuzz=enabled \
    -Dmmap=disabled \
    -Dpng=enabled \
    -Dtests=disabled \
    -Dzlib=enabled
meson compile -C build
meson install -C build
