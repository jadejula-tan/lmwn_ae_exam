SELECT
    first_interacted_campaign_id,
    first_interacted_platform,
    SUM(total_orders) AS total_orders,
    SUM(total_completed_repeat_orders) AS total_completed_repeat_orders,
    AVG(completed_orders) AS avg_completed_orders,
    AVG(total_purchase_amount) AS avg_purchase_amount,
    AVG(total_completed_purchased_amount) AS avg_completed_purchased_amount,
    AVG(time_to_first_order) AS avg_time_to_first_order,
    AVG(active_time_after_first_order) AS avg_active_time_after_first_order
FROM
    {{ ref('model_int_customer_overview') }}
WHERE
    first_interacted_campaign_id IS NOT NULL
    AND first_interacted_platform IS NOT NULL
GROUP BY
    1,
    2
ORDER BY
    1,
    2