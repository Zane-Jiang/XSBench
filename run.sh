#!/bin/bash
export OMP_NUM_THREADS=120

REBUILD=$1
MODE=${2:-11111}   
if [ "$MODE" == "latency" ]; then
    source benchmark/script/run_measure_latency.sh
else
    source benchmark/script/run_common.sh
fi

pushd benchmark/XSBench/openmp-threading

if [ $REBUILD -eq 1 ]; then
    echo "rebuilding...."
    make clean && make -j$(nproc) 
fi

if [ "$MODE" == "latency" ]; then
    run_and_measure_latency $(realpath ./XSBench) -s XXL -g 800000 -p 20000000 -l 34
else
    # For run_fourth (position 4), disable madvise
    if [[ "$MODE" =~ ^.{4}1 ]]; then
        echo "Running fourth pass with madvise disabled..."
        export CXL_MALLOC_ENABLE_MADVISE=0
    fi
    run_and_analyze $MODE $(realpath ./XSBench) -s XL -g 200000 -p 20000000 -l 34 -t 120
    # Clean up any madvise environment variable
    unset CXL_MALLOC_ENABLE_MADVISE
fi
popd
