#!/bin/bash
set -e

module load Core/gcc/8.4.0 gcc/8.4.0/llvm/10.0.0-gpu
module load Core/cuda/10.1.243
CUDA_PATH=/mnt/shared/sw-hackathons/nvidia/hpcsdk/Linux_x86_64/cuda/10.1
CUDA_LIB="${CUDA_PATH}/lib64"

pushd ../../Peano_clang

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

#export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"

export OMP_NUM_THREADS=1

export LDFLAGS="-L${CUDA_LIB} -lcudart"
export CFLAGS="--cuda-gpu-arch=sm_70 --cuda-path=${CUDA_PATH} -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -fopenmp-cuda-mode -fopenmp-version=50"
./configure  --enable-exahype --with-multithreading=omp CFLAGS="$CFLAGS" CXXFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3 finitevolumes-with-ExaHyPE2-gpu.py
export OMP_TARGET_OFFLOAD=MANDATORY
nvprof ./peano4
nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
