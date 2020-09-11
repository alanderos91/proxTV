#!/usr/bin/env bash

# AUTHOR: Alfonso Landeros
# DATE: 09/11/2020
#
# The -fopenmp option is not supported by compilers shipped with Xcode, by default.
# This installation will not support thread parallelism without a workaround.

# Set MATLAB version.
MATLABVERSION="2019b"

# Avoid name conflicts with mex.
function mexcmd () {
    /Applications/MATLAB_R${MATLABVERSION}.app/bin/mex "$@";
}

# Start script. Track failing steps.
echo 'Installing proxTV...'
cd matlab

# Compile C modules
{
mexcmd -v -c -cxx CXXOPTIMFLAGS=-O3 CXXFLAGS='$CXXFLAGS -fPIC' \
    ../src/TVgenopt.cpp \
    ../src/TVL1opt.cpp \
    ../src/TVL1Wopt.cpp \
    ../src/TVL2opt.cpp \
    ../src/TVLPopt.cpp \
    ../src/TV2Dopt.cpp \
    ../src/TV2DWopt.cpp \
    ../src/TVNDopt.cpp \
    ../src/LPopt.cpp \
    ../src/utils.cpp \
    ../src/condat_fast_tv.cpp \
    ../src/johnsonRyanTV.cpp \
    ../src/TVL1opt_tautstring.cpp \
    ../src/TVL1opt_hybridtautstring.cpp \
    ../src/TVL1opt_kolmogorov.cpp
} || {
    cd ..
    echo ''
    echo 'ERROR: proxTV installation failed on C modules. See error messages.'
    set -e
}

# Compile mex -v interfaces
{
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_condat.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_condattautstring.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_johnson.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_PN.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_linearizedTautString.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_classicTautString.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_hybridTautString.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV1_kolmogorov.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 TVL1Weighted.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 TVL1Weighted_tautString.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2_morec.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2_PGc.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2_morec2.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTVgen.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2D_DR.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2D_PD.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2D_CondatChambollePock.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2D_Yang.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2D_Kolmogorov.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV2DL1W.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV3D_Yang.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTVND_PDR.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTVp_GPFW.cpp *.o &&
mexcmd -v -cxx -lblas -llapack -lm CXXOPTIMFLAGS=-O3 solveTV.cpp *.o
} || {
    cd ..
    echo ''
    echo 'ERROR: proxTV installation failed on MEX interfaces. See error messages.'
    set -e
}

cd ..
echo ''
echo 'proxTV successfully installed.'
