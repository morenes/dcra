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
  datasets="Kron26"
  echo "Default datasets $datasets"
else
  datasets="$4"
  echo "Dataset $datasets"
fi

verbose=1
assert=0
exp="DCRA32_S"

let local_run=0
let th=32

let chiplet_w=32
let noc_conf=1
let network=1
let dcache=1
let sram_memory=256*512 # 512KB
prefix="-v $verbose -r $assert -u $noc_conf -o $network -c $chiplet_w -w $sram_memory -y $dcache -s $local_run" # skip links across chiplets :)

i=0
declare -A options
declare -A strings

####### START EXPERIMENT #######

#0: 32
let grid_w=32
strings[$i]="0 Scaling step"
options[$i]="-n ${exp}  -m $grid_w -t $th $prefix"
let i=$i+1

#1: 64
let grid_w=$grid_w*2
strings[$i]="1 Scaling step"
options[$i]="-n ${exp}  -m $grid_w -t $th $prefix"
let i=$i+1

#th=64
#2: 128
let grid_w=$grid_w*2
strings[$i]="2 Scaling step"
options[$i]="-n ${exp}  -m $grid_w -t $th $prefix"
let i=$i+1

#3: 256
let grid_w=$grid_w*2
strings[$i]="3 Max size"
options[$i]="-n ${exp}  -m $grid_w -t $th $prefix"
let i=$i+1

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done