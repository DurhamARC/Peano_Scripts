#!/bin/bash
set -e

module load gcc/9.3.1/cuda-10.1
module load cuda/10.2

pushd ../../../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

export OMP_NUM_THREADS=1

./configure  --enable-exahype --with-multithreading=omp CFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" CXXFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" LDFLAGS="-fno-devirtualize" # https://stackoverflow.com/a/59164967

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3 finitevolumes-with-ExaHyPE2-gpu.py
nvprof ./peano4
#nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
