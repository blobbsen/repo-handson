#!/bin/bash -ex

# NOTE: build function can move to osmo-ci to be commonly used.
#       If commonly used the entire build() can be replaced with
#       "source <source-file>" which holds build(). (< 20 lines)

build() {
  buildDir="$1"
  make_parallel="$2"
  not_make_check="$3"
  config="$4"

  cd "$buildDir"

  autoreconf -fi
  ./configure $config

  if [ "$make_parallel" = "" ]; then
      make -j4
  else
      make "$make_parallel"
  fi

  if [ "$not_make_check" = "" ]; then
      make check
  fi

  make install
  ldconfig

  cd "$base"
}

base=$(pwd)

build "libosmocore" "" "" "ac_cv_path_DOXYGEN=false"
build "libosmo-abis"
build "libosmo-netif"
build "libosmo-sccp" "" "" ""
build "libsmpp34" "-j1"
build "asn1c" "" "no make check" ""
build "libasn1c"
build "osmo-iuh"
build "openggsn"
build "openbsc/openbsc" "" "no make check"
build "osmo-hlr" "" "no make check"
