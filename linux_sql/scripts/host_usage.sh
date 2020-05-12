#!/bin/bash
#karan khalsa, 05/12/2020
#Script for inputing machine usage into a database
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
#save memory command
free_out=$(free -k)
#save memory command
stat_out=$(mpstat)
#save timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
#save memory free in MB
memory_free=$( echo "$free_out" | egrep "^Mem:" | awk '{print $4*0.001}' | xargs )
#save cpu_idle
cpu_idle=$( echo "$stat_out" | egrep "all" | awk '{print $13}' | xargs )
#save cpu_kernal
cpu_kernel=$( echo "$stat_out" | egrep "all" | awk '{print $6}' | xargs )
#save disk_io
disk_io=$( vmstat -d | egrep "sda" | awk '{print $10}' | xargs )
#save disk_available
disk_available=$( df -mT / | egrep "sda2" | awk '{print $5}' | xargs )

#database insert command
insert_cmd="INSERT INTO host_usage (time_stamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
            VALUES(
            '$timestamp',
            1,
            $memory_free,
            $cpu_idle,
            $cpu_kernel,
            $disk_io,
            $disk_available);"
#database insert execution
psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$insert_cmd"

exit 0