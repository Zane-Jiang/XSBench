#!/bin/bash
source benchmark/script/run_common.sh
source benchmark/script/run_measure_latency.sh
export OMP_NUM_THREADS=120

pushd benchmark/XSBench/openmp-threading
REBUILD=$1
if [ $REBUILD -eq 1 ]; then
    echo "rebuilding...."
    make clean && make -j$(nproc) 
fi

MODE=${2:-111}   

if [ "$MODE" == "latency" ]; then
    run_and_measure_latency $(realpath ./XSBench) -m event -s XXL -g 800000 -p 20000000 -l 34
else
    run_and_analyze $MODE $(realpath ./XSBench) -m event -s XXL -g 800000 -p 20000000 -l 34
fi
# run_and_analyze $MODE $(realpath ./XSBench) -m event -s XXL -l 34 -p 20000000 -G nuclide
popd