WITH order_incentive_aggregated AS (
    SELECT
        incentive_program,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'completed' THEN order_id END) AS completed_orders,
        AVG(delivery_time_minutes) AS average_delivery_time_minutes,
        AVG(time_to_accept_minutes) AS average_time_to_accept_minutes,
        SUM(total_amount) AS total_order_amount,
        SUM(CASE WHEN order_status = 'completed' THEN total_amount ELSE 0 END) AS total_completed_order_amount
    FROM
        {{ ref('model_int_order_incentive_responsiveness') }}
    GROUP BY
        1
)
SELECT
    *,
    completed_orders / NULLIF(total_orders, 0) AS completed_order_rate
FROM
    order_incentive_aggregated