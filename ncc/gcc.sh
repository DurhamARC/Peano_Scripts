#!/bin/bash
set -e

#module load cuda/10.1-cudnn7.6
module load cuda/10.1

source $HOME/peano-python-api/bin/activate

pushd ../../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

export OMP_NUM_THREADS=1
export CC="gcc-10"
export CXX="g++-10"

#./configure --enable-exahype --with-multithreading=omp --with-nvidia CXXFLAGS="-DUseLogService=NVTXLogger -foffload=-lm -fno-fast-math -fno-associative-math -I/apps/cuda/cuda-10.1-cudnn7.6/include" LDFLAGS="-L/apps/cuda/cuda-10.1-cudnn7.6/lib64 -lcudart -lnvToolsExt"
#./configure --enable-exahype --with-nvidia --with-multithreading=omp CXXFLAGS="-v -fno-stack-protector -DUseLogService=NVTXLogger -foffload=-lm -fno-fast-math -fno-associative-math -I/apps/cuda/cuda-10.1-cudnn7.6/include" LDFLAGS="-L/apps/cuda/cuda-10.1-cudnn7.6/lib64 -lcudart -lnvToolsExt"
#./configure --enable-exahype --with-multithreading=omp CXXFLAGS="-v -fno-stack-protector -DUseLogService=NVTXLogger -foffload=-lm -fno-fast-math -fno-associative-math -I/apps/cuda/cuda-10.1-cudnn7.6/include" LDFLAGS="-L/apps/cuda/cuda-10.1-cudnn7.6/lib64 -lcudart -lnvToolsExt"

#export LD_LIBRARY_PATH="/apps/cuda/cuda10.1/lib64:$LD_LIBRARY_PATH"
#export LIBRARY_PATH="/apps/cuda/cuda10.1/lib64:$LIBRARY_PATH"
./configure --enable-exahype --with-multithreading=omp CXXFLAGS="-v -fno-stack-protector -DUseLogService=NVTXLogger -foffload=-lm -fno-fast-math -fno-associative-math -I/apps/cuda/cuda-10.1/include" LDFLAGS="-L/apps/cuda/cuda-10.1/lib64 -lcudart -lnvToolsExt"
#./configure --enable-exahype --with-nvidia --with-multithreading=omp CXXFLAGS="-v -fno-stack-protector -DUseLogService=NVTXLogger -foffload=-lm -fno-fast-math -fno-associative-math -I/apps/cuda/cuda-10.1/include" LDFLAGS="-L/apps/cuda/cuda-10.1/lib64 -lcudart -lnvToolsExt"

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3.7 finitevolumes-with-ExaHyPE2-parallel.py
./peano4
#nvprof ./peano4
#nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
