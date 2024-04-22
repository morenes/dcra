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
  datasets="Kron25"
    echo "Default datasets $datasets"
else
  datasets="$4"
  echo "Dataset $datasets"
fi

exp="SCL"
verbose=1
assert=0

local_run=0
let noc_conf=1
prefix="-v $verbose -r $assert -u $noc_conf -s $local_run"

i=0
declare -A options
declare -A strings

if [ $datasets = "Kron26" ]; then
  grid_w=256
elif [ $datasets = "Kron25" ]; then
  grid_w=128
else
  exit 1
fi
th=32

let dcache_active=0
strings[$i]="0--Dalorex-512KB" 
options[$i]="-n ${exp}0 -t $th $prefix -m $grid_w -c $grid_w -k $grid_w -l 0 -y $dcache_active"
let i=$i+1


# DCRA-SRAM: No board, means the package size is 16 chiplets by default
let chiplet_w=32
strings[$i]="1--DCRA-SRAM"
options[$i]="-n ${exp}1 -t $th $prefix -m $grid_w -c $chiplet_w -y $dcache_active" # inter-die NoC
let i=$i+1


# DCRA-HBM: 16x less tiles than DCRA-SRAM
let grid_w=$grid_w/4
th=16
let dcache_active=1
strings[$i]="2--2.5D Package with DCRA dies and HBM dies"
options[$i]="-n ${exp}2 -t $th $prefix -m $grid_w -c $chiplet_w -y $dcache_active"
let i=$i+1

############################################
# Dalorex 2M, 4x more tiles than DCRA-HBM
let grid_w=$grid_w*2

strings[$i]="3--Dalorex 2MB"
let sram_mem=256*2048 # 2MB
options[$i]="-n ${exp}3 -t $th $prefix -m $grid_w -c $grid_w -k $grid_w -l 0 -y 0 -w $sram_mem"
let i=$i+1


for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
