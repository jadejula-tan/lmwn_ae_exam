WITH order_aggregated AS (
    SELECT
        restaurant_id,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN is_reorder_after_complaint THEN order_id END) AS total_reorder_customers_after_complaint
    FROM
        {{ ref('model_int_reorder_after_complaint_flag') }}
    GROUP BY
        1
)
SELECT
    r.restaurant_id,
    r.restaurant_name,
    rf.total_tickets,
    rf.issue_raised_ranked,
    rf.total_resolution_time_minutes AS total_resolution_minutes,
    rf.total_tickets_with_compensation,
    rf.total_compensation_amount,
    rf.total_tickets / NULLIF(oa.total_orders, 0) AS issue_rate,
    rf.total_customers AS total_customer_with_complaints,
    oa.total_reorder_customers_after_complaint,
    rf.total_customers / NULLIF(oa.total_orders, 0) AS reorder_customer_lost_ratio
FROM
    {{ ref('model_stg_restaurant') }} AS r
LEFT JOIN
    {{ ref('model_int_restaurant_feedback') }} AS rf
ON
    r.restaurant_id = rf.restaurant_id
LEFT JOIN
    order_aggregated AS oa
ON
    r.restaurant_id = oa.restaurant_id
WHERE
    rf.total_tickets IS NOT NULL
    AND r.active_status = 'active'
ORDER BY
    rf.total_tickets DESC