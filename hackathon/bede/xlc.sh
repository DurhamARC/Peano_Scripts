#!/bin/bash
set -e

module load ibm/xl/xlC16.1.1
module load cuda/10.2
#module load ibm/at/at12.0

pushd ../../../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

#export CC=xlc++
export CXX=xlc++
 
#export CC=g++
#export CC=xlclang++

#export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"
#export CXXFLAGS="–qsmp=omp -qoffload"
export CXXFLAGS="-qsmp=omp -qoffload -std=c++11"

export OMP_NUM_THREADS=1

./configure --enable-exahype --with-nvidia --with-multithreading=omp CXXFLAGS="$CXXFLAGS"

make -j 8
#pushd python/examples/exahype2/euler/
#export PYTHONPATH=../../../
#python3 finitevolumes-with-ExaHyPE2-gpu.py

#nvprof ./peano4
#nsys profile --trace=cuda,nvtx,openmp --output=my_report.qdrep ./peano4
