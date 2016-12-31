#!/bin/bash
distdir=.dist

go_build() {
  rm -rf "${distdir}"
  mkdir "${distdir}"
  glide install
  echo " ---- after glide install ---- "
  CGO_ENABLED=0 go build -v -o ${distdir}/$1
  echo " ---- finished ---- "
  echo ${distdir}/$1
  ls -la ${distdir}/$1
}

go_build