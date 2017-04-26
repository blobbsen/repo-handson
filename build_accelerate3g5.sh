#!/bin/bash -ex

# NOTE: build function can move to osmo-ci to be commonly used.
#       If commonly used the entire build() can be replaced with
#       "source <source-file>" which holds build(). (< 20 lines)

build() {
  buildDir="$1"
  config="$2"
  not_make_check="$3"
  make_parallel="$4"
  generic_make=""

  if [[ "$(uname)" == *"FreeBSD"* ]]; then
    generic_make="gmake"
  else
    generic_make="make"
  fi

  cd "$buildDir"

  autoreconf -fi
  ./configure $config

  if [ "$make_parallel" = "" ]; then
      "$generic_make" -j4
  else
      "$generic_make" "$make_parallel"
  fi

  if [ "$not_make_check" = "" ]; then
      "$generic_make" check
  fi

  "$generic_make" install
  ldconfig

  cd "$base"
}

base=$(pwd)

build "libosmocore" "ac_cv_path_DOXYGEN=false"
build "libosmo-abis"
build "libosmo-netif"
build "libosmo-sccp"
build "libsmpp34" "" "" "-j1"
build "asn1c" "" "no make check"
build "libasn1c"
build "osmo-iuh"
build "openggsn"
build "openbsc/openbsc" "--enable-nat --enable-iu --enable-mgcp-transcoding" "--no-mkcheck"
build "osmo-hlr" "" "no make check"
