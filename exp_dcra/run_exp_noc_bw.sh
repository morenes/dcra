#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Error: Missing required parameters."
    exit 1
fi

if [ $1 -gt 8 ]; then
  apps="0 2 3 4 5"
else
  apps=$1
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

exp="NOCM"
verbose=1
assert=0

let dcache=0

# Run mode
let local_run=0
let grid_x=$4
let chiplet_w=16
let th=16

prefix="-v $verbose -r $assert -y $dcache -s $local_run -c $chiplet_w"

let noc_conf=0
let torus=0

#"0--Mesh"
options="-n ${exp}0 -t $th $prefix -m $grid_x -u $noc_conf -o $torus -l 0"
run 0

#"1--Mesh_wide"
let noc_conf=1
options="-n ${exp}1 -t $th $prefix -m $grid_x -u $noc_conf -o $torus -l 0"
run 1

#"2--Torus_wide"
let torus=1
options="-n ${exp}2 -t $th $prefix  -m $grid_x -u $noc_conf -o $torus -l 0"
run 2

#"3--Torus_wide + inter-die"-skip (ruche is inter-die when not defined)
options="-n ${exp}3 -t $th $prefix  -m $grid_x -u $noc_conf -o $torus"
run 3

#"4--Torus 2x"
var=noc_freq; value=2.0; set
options="-n ${exp}4 -t $th $prefix  -m $grid_x -u $noc_conf -o $torus"
run 4


var=noc_freq; value=1.0; set