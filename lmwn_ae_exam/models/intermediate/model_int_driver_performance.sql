WITH driver_performance_aggregated AS(
    SELECT
        driver_id,
        COUNT(DISTINCT order_id) AS total_tasks,
        COUNT(DISTINCT CASE WHEN LOWER(order_status) = 'completed' THEN order_id END) AS total_completed_tasks,
        COUNT(DISTINCT CASE WHEN LOWER(order_status) = 'completed' AND is_late_delivery THEN order_id END) AS late_completed_tasks,
        AVG(DATE_DIFF('minute',pickup_datetime,delivery_datetime)) AS avg_delivery_minutes,
        AVG(time_to_accept_minutes) AS avg_time_to_accept_minutes
    FROM
        {{ ref('model_int_order_responsiveness') }}
    GROUP BY
        1
)
SELECT
    *,
    total_completed_tasks / NULLIF(total_tasks, 0) AS completion_rate,
    late_completed_tasks / NULLIF(total_completed_tasks, 0) AS late_completion_rate
FROM
    driver_performance_aggregated