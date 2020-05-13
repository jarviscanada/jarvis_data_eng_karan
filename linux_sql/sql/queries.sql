--Karan Khalsa 05/13/2020
--psql queries to better see cluster usage

--Grouping hosts by hardware info
SELECT
    host_info.cpu_number AS cpu_number,
    host_info.id AS host_id,
    host_info.total_mem AS total_mem
    FROM host_info
    GROUP BY cpu_number, host_id
    ORDER BY total_mem DESC;

--find average used memeory percentage over 5 min intervals
SELECT
    host_usage.host_id AS host_id,
    host_info.hostname AS hostname,
    DATE_TRUNC('hour', host_usage.time_stamp) + INTERVAL '5 minutes' *
        ROUND(DATE_PART('minutes', host_usage.time_stamp)/5.0) AS new_time_stamp,
    ROUND ((AVG(CAST((host_info.total_mem - (host_usage.memory_free*1024)) AS FLOAT) /
        host_info.total_mem * 1.0)*100)::NUMERIC,0)  AS used_mem_percentage
FROM
    host_usage
    INNER JOIN host_info ON host_usage.host_id=host_info.id
GROUP BY
    host_id,
    hostname,
    total_mem,
    new_time_stamp
ORDER BY
    host_usage.host_id;