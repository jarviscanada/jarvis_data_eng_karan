#!/bin/bash
#karan khalsa, 05/12/2020
#Script for inputing machine usage into a database
#Setup arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_pwd=$5

#Main code
#save hostname
hostname=$(hostname -f)
#save memory command
free_out=$(free -k)
#save memory command
stat_out=$(mpstat)
#save timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
#save memory free in MB
memory_free=$( echo "$free_out" | egrep "^Mem:" | awk '{print $4*0.001}' | xargs )
#save cpu_ideal
cpu_ideal=$( echo "$stat_out" | egrep "all" | awk '{print $13}' | xargs )
#save cpu_kernal
cpu_kernal=$( echo "$stat_out" | egrep "all" | awk '{print $6}' | xargs )
#save disk_io
disk_io=$( vmstat -d | egrep "sda" | awk '{print $10}' | xargs )
#save disk_available
disk_available=$( df -mT / | egrep "sda2" | awk '{print $5}' | xargs )