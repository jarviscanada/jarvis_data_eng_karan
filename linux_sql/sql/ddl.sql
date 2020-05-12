--Karan Khalsa 05/12/2020
--Automation file to create db tables

--CREATE TABLE host_info if it does not exist
CREATE TABLE IF NOT EXISTS PUBLIC.host_info(
    id serial NOT NULL PRIMARY KEY,
    hostname VARCHAR UNIQUE NOT NULL,
    cpu_number INT NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz INT NOT NULL,
    L2_cache INT NOT NULL,
    total_mem INT NOT NULL,
    time_stamp TIMESTAMP NOT NULL);

--CREATE TABLE host_usage if it does not exist
CREATE TABLE PUBLIC.host_usage(
    time_stamp TIMESTAMP NOT NULL PRIMARY KEY,
    host_id serial NOT NULL REFERENCES host_info(id),
    memory_free INT NOT NULL,
    cpu_idle INT NOT NULL,
    cpu_kernel INT NOT NULL,
    disk_io INT NOT NULL,
    disk_available INT NOT NULL);
