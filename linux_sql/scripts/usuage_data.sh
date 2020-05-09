#!/bin/bash
#save hostname
hostname=$(hostname -f)
echo "$hostname"

#save cpu list command
lscpu_out=$( lscpu )
echo $lscpu_out

#save cpu number
cpu_number=$( lscpu | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )
echo "$cpu_number"

#save cpu arch
cpu_architecture=$( lscpu | egrep "^Architecture:" | awk '{print $2}' | xargs )
echo $cpu_architecture

#save cpu model
cpu_model=$( lscpu | egrep "^Model:" | awk '{print $2}' | xargs )
echo $cpu_model

#save cpu mhz
cpu_mhz=$( lscpu | egrep "^CPU\ MHz:" | awk '{print $2}' | xargs )
echo $cpu_mhz

#save cpu l2_cache
l2_cache=$( lscpu | egrep "^Architecture:" | awk '{print $2}' | xargs )
echo $l2_cache

#save total_mem
total_mem=$( lscpu | egrep "^Architecture:" | awk '{print $2}' | xargs )
echo $total_mem

timestamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$timestamp"


