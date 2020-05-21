set -e

pushd ../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

export PEANO_CXXFLAGS="-I/usr/include/vtk"
export CXXFLAGS="-I/usr/include/vtk"

PEANO_CXXFLAGS="-I/usr/include/vtk" ./configure --enable-exahype --with-vtk --with-vtk-version=8

make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
python3 finitevolumes-with-ExaHyPE2.py
#python3 finitevolumes-with-ExaHyPE2-parallel.py
