#!/bin/bash
#save hostname
hostname=$(hostname -f)
echo "$hostname"

#save cpu list command
lscpu_out=$(lscpu)

#save memory command
free_out=$(free -k)

#save memory command
stat_out=$(mpstat)

#save cpu number
cpu_number=$( echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )
echo "$cpu_number"

#save cpu arch
cpu_architecture=$( echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs )
echo $cpu_architecture

#save cpu model
cpu_model=$( echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs )
echo $cpu_model

#save cpu mhz
cpu_mhz=$( echo "$lscpu_out" | egrep "^CPU\ MHz:" | awk '{print $3}' | xargs )
echo $cpu_mhz

#save cpu l2_cache in KB
l2_cache=$( echo "$lscpu_out" | egrep "^L2\ cache:" | awk '{print $3}' | xargs )
echo $l2_cache

#save total_mem in KB
total_mem=$( echo "$free_out" | egrep "^Mem:" | awk '{print $2}' | xargs )
echo $total_mem

#save timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$timestamp"

#save memory free in MB
memory_free=$( echo "$free_out" | egrep "^Mem:" | awk '{print $4*0.001}' | xargs )
echo $memory_free

#save cpu_ideal
cpu_ideal=$( echo "$stat_out" | egrep "all" | awk '{print $13}' | xargs )
echo $cpu_ideal

#save cpu_kernal
cpu_kernal=$( echo "$stat_out" | egrep "all" | awk '{print $6}' | xargs )
echo $cpu_kernal

#save disk_io
disk_io=$( vmstat -d | egrep "sda" | awk '{print $10}' | xargs )
echo $disk_io

#save disk_available
disk_available=$( df -mT / | egrep "sda2" | awk '{print $5}' | xargs )
echo $disk_available

exit 0
