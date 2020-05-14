#!/bin/bash
#karan khalsa, 05/12/2020
#Script for inputing machine information into a database
#Setup arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

export PGPASSWORD=${psql_password}

#validate arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

#Main code
lscpu_out=$(lscpu)
free_out=$(free -k)
hostname=$(hostname -f)
cpu_number=$( echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs )
cpu_architecture=$( echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs )
cpu_model=$( echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs )
cpu_mhz=$( echo "$lscpu_out" | egrep "^CPU\ MHz:" | awk '{print $3}' | xargs )
l2_cache=$( echo "$lscpu_out" | egrep "^L2\ cache:" | awk '{print $3}' | sed 's/K//' | xargs )
total_mem=$( echo "$free_out" | egrep "^Mem:" | awk '{print $2}' | xargs )
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

#database insert command
insert_cmd="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem,
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
psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$insert_cmd"

exit $?