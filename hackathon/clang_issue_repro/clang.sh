#!/bin/bash
module load Core/gcc/8.4.0  gcc/8.4.0/llvm/10.0.0-gpu
module load Core/cuda/10.1.243
CUDA_PATH=/mnt/shared/sw-hackathons/nvidia/hpcsdk/Linux_x86_64/cuda/10.1
CUDA_LIB="${CUDA_PATH}/lib64"

#clang++ -fopenmp=libiomp5 -fopenmp-targets=nvptx64-nvidia-cuda -o main main.cpp
clang++ -fopenmp=libomp -fopenmp-targets=nvptx64-nvidia-cuda -o main main.cpp
