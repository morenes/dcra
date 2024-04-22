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
setsmt() {
  sed -i "s/\(${var}\s*=\s*\)[^;]*/\1${value}/" "src/configs/config_system.h"
}

exp="GRANU"
verbose=1
assert=0


let dcache=1
# Run mode
let local_run=0
let th=16

prefix="-v $verbose -r $assert -y $dcache -s $local_run"

let torus=1

#0 Torus-32b, SMT=1
let sram_memory=256*512
var=smt_per_tile; value=1; setsmt
let chiplet_w=$grid_w/4
options="-n ${exp}0 -t $th $prefix -m $grid_w -u 0 -o $torus -c $chiplet_w -w $sram_memory -k $grid_w"
run 0


#1 Torus-64b, SMT=4
let sram_memory=$sram_memory*4
let grid_w=$grid_w/2
let chiplet_w=$grid_w/4
var=smt_per_tile; value=4; setsmt
options="-n ${exp}1 -t $th $prefix -m $grid_w -u 1 -o $torus -c $chiplet_w  -w $sram_memory -k $grid_w"
run 1


#2 Torus-64b 2GHZ, SMT=16
let sram_memory=$sram_memory*4
let grid_w=$grid_w/2
let chiplet_w=$grid_w/4
var=noc_freq; value=2.0; set
var=smt_per_tile; value=16; setsmt
options="-n ${exp}2 -t $th $prefix -m $grid_w -u 1 -o $torus -c $chiplet_w  -w $sram_memory -k $grid_w"
run 2


var=noc_freq; value=1.0; set
var=smt_per_tile; value=1; setsmt