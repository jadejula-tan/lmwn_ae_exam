{#
    To correctly calculate the cancellation rate due to unaviable drivers,
    we should first match to the order cancellation reason log or ticket. However, this data
    is not provided, for simplification, we will assume that all cancellations are due to unavailability.
#}
WITH delivery_zone_overview AS (
    SELECT
        delivery_zone,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'completed' THEN order_id END) AS total_completed_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'canceled' THEN order_id END) AS total_cancelled_orders,
        AVG(DATE_DIFF('minute', pickup_datetime, delivery_datetime)) AS avg_delivery_time_minutes,
        AVG(delivery_distance_km) AS avg_delivery_distance_km,
        COUNT(DISTINCT CASE WHEN order_status = 'completed' AND is_late_delivery THEN order_id END) AS total_late_deliveries

    FROM
        {{ ref('model_stg_orders') }}
    GROUP BY
        delivery_zone
)
SELECT
    *,
    total_completed_orders / NULLIF(total_orders, 0) AS completion_rate,
    total_cancelled_orders / NULLIF(total_orders, 0) AS cancellation_rate,
    total_late_deliveries / NULLIF(total_completed_orders, 0) AS late_delivery_rate
FROM
    delivery_zone_overview