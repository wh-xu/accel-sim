#!/bin/bash

SCRIPT_DIR="GPU_Microbenchmark"
echo "Running make in $SCRIPT_DIR"
make -C "$SCRIPT_DIR" tuner -j || { echo "make failed"; exit 1; }

cd ${SCRIPT_DIR}/bin/
for f in ./*; do
    if [[ "$f" == *_corr ]]; then
        continue
    fi

    echo "running $f microbenchmark"
    $f
    echo "/////////////////////////////////"
done