#!/bin/bash -ex

cloneRepoAndSetCorrectHead(){
  cd "$osmo_src"
  repo=$(echo $1 | cut -d '/' -f1)
  git clone "git://git.osmocom.org/$repo"
  cd "$1"
  $2
  $3
}

build() {

  buildDir=$1
  make_parallel=$2
  not_make_check="$3"
  config="$4"
  ApplyBranch=$5
  orTag=$6

  cloneRepoAndSetCorrectHead "$buildDir" "$ApplyBranch" "$orTag"

  autoreconf -fi
  ./configure "$config"

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
}

osmo_src=$HOME/osmo/src
mkdir -p $osmo_src

build "libosmocore"
build "libosmo-abis"
build "libosmo-netif"
build "libosmo-sccp" "" "" "" "git tag -l" "git checkout tags/old_sua"
build "libsmpp34" "-j1"
build "asn1c" "" "no make check" "" "git checkout aper-prefix-onto-upstream"
build "libasn1c"
build "osmo-iuh"
build "openggsn"
build "openbsc/openbsc" "" "" "--enable-iu --enable-mgcp-transcoding" "git checkout vlr_3G"
build "osmo-hlr"
