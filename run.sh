#!/bin/bash
export OMP_NUM_THREADS=120

REBUILD=$1
MODE=${2:-11111}   

source benchmark/script/run_common.sh


pushd benchmark/XSBench/openmp-threading
if [ $REBUILD -eq 1 ]; then
    echo "rebuilding...."
    make clean && make -j$(nproc) 
fi
run_and_analyze $MODE $(realpath ./XSBench) -s XL -g 200000 -p 20000000 -l 34 -t 120
fi
popd
