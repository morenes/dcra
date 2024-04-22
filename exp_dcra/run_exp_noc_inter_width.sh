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
exp="NOCW"

i=0

let chiplet_w=16
let proxy_w=$grid_w
#let board_w=$grid_w #Specify board so that the package has the same size as the board
let dcache=0

 
local_run=0

sufix="-v $verbose -r $assert -t $th -m $grid_w -c $chiplet_w -e $proxy_w -y $dcache -s $local_run" # -k $board_w

# NOC_CONF:4 means 1 NoC of 32 bit
# NOC_CONF:0 means 2 NoCS of 32 bits intra die, which get throttled to a shared 32 bits across dies
# NOC_CONF:1 means 2 NoCS of 32 and 64 bit intra die, which get throttled to a shared 32 bits across dies
# NOC_CONF:2 means 2 NoCS of 32 and 64 bit intra die, which get throttled to 2 NoCs of 32 and 32 bits across dies
# NOC_CONF:3 means 2 NoCS of 32 and 64 bit intra and inter-die

# u: noc conf, l: long-wires Ruche, o: torus, x:num_phy_nocs
strings[$i]="${exp}N0" # Mesh 32
options[$i]="-n ${strings[$i]} -u 0  $sufix -o 0 -l 0 -x 1"
let i=$i+1

strings[$i]="${exp}N1" # Torus 32
options[$i]="-n ${strings[$i]} -u 0  $sufix -o 1 -l 0 -x 1"
let i=$i+1

strings[$i]="${exp}N2" # Torus 64 : 32
options[$i]="-n ${strings[$i]} -u 1  $sufix -o 1 -l 0 -x 1"
let i=$i+1

# strings[$i]="${exp}N3" # Torus 32+64 : 32
# options[$i]="-n ${strings[$i]} -u 1  $sufix -o 1 -l 0"
# let i=$i+1

# strings[$i]="${exp}N4" # Torus 32+64 : 32+32
# options[$i]="-n ${strings[$i]} -u 2  $sufix -o 1 -l 0"
# let i=$i+1

# strings[$i]="${exp}N5" # Noc3
# options[$i]="-n ${strings[$i]} -u 3  $sufix -o 1 -l 0"
# let i=$i+1

strings[$i]="${exp}N7" # Noc2 + Inter-die
options[$i]="-n ${strings[$i]} -u 1  $sufix -o 1"
let i=$i+1


for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
