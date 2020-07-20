#!/bin/bash
set -e

module load Bundle/gnu/10.1.0-gpu
module load Core/cuda/10.1.243
export CUDA_PATH=/mnt/shared/sw-hackathons/nvidia/hpcsdk/Linux_x86_64/cuda/10.1
export CUDA_LIB="${CUDA_PATH}/lib64"

#module load cuda/11.0.2
#export CUDA_PATH=/mnt/shared/sw-hackathons/nvidia/hpcsdk/Linux_x86_64/cuda/11.0
#export CUDA_LIB="${CUDA_PATH}/lib64"

pushd ../../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

#export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"

export OMP_NUM_THREADS=1

./configure  --enable-exahype --with-multithreading=omp CFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" CXXFLAGS="-fno-devirtualize -foffload=-lm -fno-fast-math -fno-associative-math" LDFLAGS="-fno-devirtualize" # https://stackoverflow.com/a/59164967

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3 finitevolumes-with-ExaHyPE2-gpu.py
nvprof ./peano4
nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
