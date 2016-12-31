#!/bin/bash
distdir=.dist

go_build() {
    echo " ---- before rm ---- "
    ls -la
  rm -rf "${distdir}"
  echo " ---- before mkdir ---- "
  ls -la
  mkdir "${distdir}"
  echo " ---- after mkdir ---- "
  ls -la
  glide install
  CGO_ENABLED=0 go build -v -o ${distdir}/$1
  echo " ---- finished ---- "
  ls -la ${distdir}/$1
}

go_build