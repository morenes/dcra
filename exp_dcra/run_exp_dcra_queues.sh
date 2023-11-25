#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    exit 1
fi
if [ $1 -gt 8 ]; then
  apps="0 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  echo "Default grid_w=64"
  let grid_w=64
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

declare -A options
declare -A strings

th=16
verbose=1
assert=0
exp="OQUEUE"

i=0

let chiplet_w=16
let proxy_w=$grid_w

let noc_conf=1
let dcache=0

# Run on Della:0 (need to be logged into della), run on Chai:1
local_run=0

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -e $proxy_w -y $dcache -s $local_run"


# *1
strings[$i]="${exp}1"
options[$i]="-n ${strings[$i]} -g 1 $sufix"
let i=$i+1

# *4
strings[$i]="${exp}3"
options[$i]="-n ${strings[$i]} -g 3 $sufix"
let i=$i+1

# *8
strings[$i]="${exp}4"
options[$i]="-n ${strings[$i]} -g 4 $sufix"
let i=$i+1

# *16
strings[$i]="${exp}5"
options[$i]="-n ${strings[$i]} -g 5 $sufix"
let i=$i+1

# *32
strings[$i]="${exp}6"
options[$i]="-n ${strings[$i]} -g 6 $sufix"
let i=$i+1


for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
