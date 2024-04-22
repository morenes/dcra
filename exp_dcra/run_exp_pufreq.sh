#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    exit 1
fi

if [ $1 -gt 8 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  let grid_w=64
  echo "Default grid_w=$grid_w"
else
  let grid_w=$4
  echo "grid_w=$grid_w"
fi
if [ -z "$5" ]; then
  echo "All datasets by default"
  datasets="Kron22 wikipedia"
else
  echo "Dataset $5"
  datasets="$5"
fi

let lb=$2
let ub=$3
run() {
    local i="$1"
    if [ $lb -le $i ] && [ $ub -ge $i ]; then
        echo "EXPERIMENT: $i"
        exp/run.sh $options -d "$datasets" -a "$apps"
    fi
}

set() {
  sed -i "s/\(${var}\s*=\s*\)[^;]*/\1${value}/" "src/configs/param_energy.h"
}

exp="PUF"
verbose=1
assert=0

let sram_memory=256*512
let dcache=0

# Run mode
let local_run=0
let th=16
let chiplet_w=16 # So that the NoC is more the bottleneck than the memory

prefix="-v $verbose -r $assert -w $sram_memory -y $dcache -s $local_run -c $chiplet_w"

let noc_conf=1
let torus=1

#"0--"
var=pu_freq; value=0.25; set
options="-n ${exp}0 -t $th $prefix -m $grid_w -u $noc_conf -o $torus"
run 0

#"1--"
var=pu_freq; value=0.50; set
options="-n ${exp}1 -t $th $prefix -m $grid_w -u $noc_conf -o $torus"
run 1

#"2--"
# var=pu_freq; value=1.0; set
# options="-n ${exp}2 -t $th $prefix -m $grid_w -u $noc_conf -o $torus"
# run 2

#"4--"
var=pu_freq; value=2.0; set
options="-n ${exp}4 -t $th $prefix -m $grid_w -u $noc_conf -o $torus"
run 4

var=pu_freq; value=1.0; set