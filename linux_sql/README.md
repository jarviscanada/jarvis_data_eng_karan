# Linux Cluster Monitoring Agent
## Introduction
The Cluster Monitoring Agent is a tool developed to help administration teams manage Linux cluster of nodes/ servers.
This tool will be used to record hardware specifications (e.g: # of CPU(s)) of each node and monitor node resources usage
(e.g: Free Memory). The admin team can then use this data to generate reports for future resource planning purpose.

## Architecture and Design
![Linux Arch Image](https://github.com/jarviscanada/jarvis_data_eng_karan/blob/feature/readme/linux_sql/assets/Linux_Arch_Image.png?raw=true)

On the main server, a PSQL instance was created using a docker image. From there a database and two tables were created
 to store the appropriate information. All remaining servers were then fitted with bash scripts running on a crontab
  to send usage to send data to the database.
##### Database:
  - A PostgresSQL database (host_agent) was used to store the data from each server
  - Two tables (host_info, host_usage) were created using the [ddl.sql] script
  - The data was then queried to provide useful summaries using [queries.sql] script
   
##### Scripts:
  - The docker container was created using [psql_docker.sh] bash script
  - The server information was passed to the database using the [host_info.sh]
   bash script
  - The server usage was passed to the database using the [host_usage.sh] bash script and was automated to run every
  minute using crontab automation
   
## Usage
**1. Initialize the PSQL instance**

  1.1 Set up the docker container and start the container using [psql_docker.sh] script and CLI

     # Create PSQL docker container from the machines home directory
     ./linux_sql/scripts/psql_docker.sh create psql_user psql_password
     
     # Start the container
     ./linux_sql/scripts/psql_docker.sh start psql_user psql_password

**2. Create database and tables**

*Note: Docker container must be running in order to proceed. Docker containers may have shut down if the server was
turned off*

  2.1 Connect to PSQL using CLI (will be asked for psql_password from step 1)
  
      # Connect to PSQL
      psql -h psql_host -U psql_user -W
  
  2.2 Create the database using CLI
    
       # Create the database
       CREATE DATABASE host_agent;
       
  2.3 Create database tables using CLI and script
    
       # Create the tables
       psql -h psql_host -U psql_user -d db_name -f ./linux_sql/sql/ddl.sql

**3. Set up hardware information and usage data transfer**

  3.1 Send hardware information using [host_info.sh] script and CLI
  
       # Loads server specs into PSQL database
       ./linux_sql/scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
  
  3.2 Setup hardware usage data transfer using [host_usage.sh] script, crontab and CLI
  
   3.2.1 Send test data to database using CLI
   
         # Loads server resource usage into PSQL database
         ./linux_sql/scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
         
   3.2.2 Setup a crontab job to automatically send data to database using CLI
      
         # Create/ edit crontab jobs
         crontab -e
         
         # Sets the bash script to run every minute and log results
         * * * * * bash [path]/host_usage.sh psql_host psql_port db_name psql_user psql_password &> /tmp/host_usage.log
         
         # Verify job is running by listing current crontab jobs
         crontab -ls
        
## Improvements

1. Consolidate all setup commands into a single script and automate using an executable
2. Add alerts to notify administration of any serious issues (e.g: server offline, server disconnected)
3. Add database creation into [ddl.sql] script to simplify process


[host_info.sh]: https://github.com/jarviscanada/jarvis_data_eng_karan/blob/develop/linux_sql/scripts/host_info.sh
[host_usage.sh]: https://github.com/jarviscanada/jarvis_data_eng_karan/blob/develop/linux_sql/scripts/host_usage.sh
[psql_docker.sh]: https://github.com/jarviscanada/jarvis_data_eng_karan/blob/develop/linux_sql/scripts/psql_docker.sh
[ddl.sql]: https://github.com/jarviscanada/jarvis_data_eng_karan/blob/develop/linux_sql/sql/ddl.sql
[queries.sql]: https://github.com/jarviscanada/jarvis_data_eng_karan/blob/develop/linux_sql/sql/queries.sql