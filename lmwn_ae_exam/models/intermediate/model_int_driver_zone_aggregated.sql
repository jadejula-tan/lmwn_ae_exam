SELECT
    region,
    COUNT(DISTINCT driver_id) AS total_drivers,
    COUNT(DISTINCT CASE WHEN active_status = 'active' THEN driver_id END) AS total_active_drivers
FROM
    {{ ref('model_stg_drivers') }}
GROUP BY
    1