--Karan Khalsa 05/13/2020
--psql queries to better see cluster usage

INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, time_stamp)

INSERT INTO host_usage (time_stamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)

SELECT
    host_info.cpu_number AS cpu_number,
    host_info.id AS host_id,
    host_info.total_mem AS total_mem
    FROM host_info
    GROUP BY cpu_number, host_id
    ORDER BY total_mem DESC;

SELECT
    host_usage.host_id AS host_id,
    host_info.total_mem AS total_mem,
    host_info.hostname AS hostname,
        AVG(total_mem - host_usage.memory_free)
