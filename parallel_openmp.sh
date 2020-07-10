#!/bin/bash
set -e

pushd ../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"

export OMP_NUM_THREADS=1

./configure --with-vtk --with-vtk-version=8 --with-vtk-suffix='' --enable-exahype --with-multithreading=omp CFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" CXXFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" LDFLAGS="-fno-devirtualize" # https://stackoverflow.com/a/59164967

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3 finitevolumes-with-ExaHyPE2.py
