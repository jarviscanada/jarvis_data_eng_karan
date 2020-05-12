#!/bin/bash
#karan khalsa, 05/12/2020
#Script for inputing machine information into a database
#Setup arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_pwd=$5

#Main code
#save cpu list command
lscpu_out=$(lscpu)
#save memory command
free_out=$(free -k)
#save hostname
hostname=$(hostname -f)
#save cpu number
cpu_number=$( echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )
#save cpu arch
cpu_architecture=$( echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs )
#save cpu model
cpu_model=$( echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs )
#save cpu mhz
cpu_mhz=$( echo "$lscpu_out" | egrep "^CPU\ MHz:" | awk '{print $3}' | xargs )
#save cpu l2_cache in KB
l2_cache=$( echo "$lscpu_out" | egrep "^L2\ cache:" | awk '{print $3}' | sed 's/K//' | xargs )
#save total_mem in KB
total_mem=$( echo "$free_out" | egrep "^Mem:" | awk '{print $2}' | xargs )
#save timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

#database insert command
insert_cmd="INSERT INTO HOST_INFO (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem,
            time_stamp)
            VALUES(
            '$hostname',
            '$cpu_number',
            '$cpu_architecture',
            '$cpu_model',
            $cpu_mhz,
            $l2_cache,
            $total_mem,
            '$timestamp');"
#database insert execution
psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -W -c "$insert_cmd"

exit 0