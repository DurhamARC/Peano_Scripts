set -e

pushd ../Peano

libtoolize
aclocal
autoconf
autoheader
cp src/config.h.in .
automake --add-missing

#export PEANO_CXXFLAGS="-I/usr/include/vtk-8.2"
export CPLUS_INCLUDE_PATH="/usr/include/vtk/:$CPLUS_INCLUDE_PATH"
#export LDFLAGS=”-L/usr/lib64”

#./configure --enable-exahype --enable-vtk --with-vtk-version=8 --with-vtk-suffix=''
#./configure --enable-exahype --with-vtk --with-vtk-version=8
./configure --enable-exahype --with-vtk --with-vtk-version=8 --with-vtk-suffix=''
make -j 8
pushd python/examples/exahype2/euler/
export PYTHONPATH=../../../
#python3 finitevolumes-with-ExaHyPE2.py
python3 finitevolumes-with-ExaHyPE2-parallel.py

../../../../src/visualisation/convert apply-filter solutionEuler.peano-patch-file EulerQ . extract-fine-grid finegrid
../../../../src/visualisation/convert convert-file solutionEuler.peano-patch-file finegrid . vtu

../../../../src/visualisation/convert apply-filter solutionEuler.peano-patch-file EulerQ . plot-domain-decomposition DD
../../../../src/visualisation/convert apply-filter solutionEuler.peano-patch-file DD     . extract-fine-grid finegridDD
../../../../src/visualisation/convert convert-file solutionEuler.peano-patch-file finegridDD . vtu
