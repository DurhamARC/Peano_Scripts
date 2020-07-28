#!/bin/bash
set -e


module load gcc/10.1.0/python/3.7.7
source $HOME/peano-python-api/bin/activate

module load Core/gcc/8.4.0  gcc/8.4.0/llvm/10.0.0-gpu
#module load gcc/8.4.0/llvm/10.0.0-gpu
module load gcc/8.4.0/autoconf/2.69
module load gcc/8.4.0/automake/1.16.2
module load gcc/8.4.0/libtool/2.4.6
#module load gcc/8.4.0/llvm/10.0.0
module load Core/cuda/10.1.243
CUDA_PATH=/mnt/shared/sw-hackathons/nvidia/hpcsdk/Linux_x86_64/cuda/10.1
CUDA_LIB="${CUDA_PATH}/lib64"

pushd ../../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

#export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"

export OMP_NUM_THREADS=1

export CXX="clang++"
export LDFLAGS="-L${CUDA_LIB} -lcudart -fopenmp"
#export CFLAGS="-v --cuda-gpu-arch=sm_70 --cuda-path=${CUDA_PATH} -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -fopenmp-cuda-mode -fopenmp-version=50"
#export CFLAGS="-v --cuda-gpu-arch=sm_70 --cuda-path=${CUDA_PATH} -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -fopenmp-cuda-mode -fopenmp-version=50"
#export CXXFLAGS="-v -std=c++14 --cuda-gpu-arch=sm_70 --cuda-path=${CUDA_PATH} -fopenmp -fopenmp-version=50"
export CXXFLAGS="-v -std=c++14 --cuda-gpu-arch=sm_70 --cuda-path=${CUDA_PATH} -fopenmp=libiomp5 -fopenmp-version=50"
#./configure  --enable-exahype --with-multithreading=omp CFLAGS="$CFLAGS" CXXFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
./configure  --enable-exahype --with-multithreading=omp CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" CXX="$CXX"

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
#python3 finitevolumes-with-ExaHyPE2-gpu.py
python3 finitevolumes-with-ExaHyPE2.py
#export OMP_TARGET_OFFLOAD=MANDATORY
nvprof ./peano4
#nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
