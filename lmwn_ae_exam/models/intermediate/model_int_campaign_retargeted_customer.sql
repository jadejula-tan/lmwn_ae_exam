
WITH retargeted_cust_recurring AS (
    -- Find retention bahavior based on recurring orders after different time intervals
    SELECT
        ci.campaign_id,
        ci.customer_id,
        COUNT(DISTINCT ot.order_id) AS num_recurring_orders,
        SUM(ot.total_amount) AS total_purchase_amount,
        MAX(
            CASE 
                WHEN ot.order_datetime > ci.interaction_datetime
                     AND ot.order_datetime <= ci.interaction_datetime + INTERVAL '7 day'
                THEN 1 ELSE 0 END
        ) = 1 AS has_order_within_7_days,
        MAX(
            CASE 
                WHEN ot.order_datetime > ci.interaction_datetime
                     AND ot.order_datetime <= ci.interaction_datetime + INTERVAL '15 day'
                THEN 1 ELSE 0 END
        ) = 1 AS has_order_within_15_days,
        MAX(
            CASE 
                WHEN ot.order_datetime > ci.interaction_datetime
                     AND ot.order_datetime <= ci.interaction_datetime + INTERVAL '30 day'
                THEN 1 ELSE 0 END
        ) = 1 AS has_order_within_30_days
    FROM
        {{ ref('model_int_campaign_interactions_with_details') }} AS ci
    LEFT JOIN
        {{ ref('model_stg_campaigns') }} AS c
    ON 
        ci.campaign_id = c.campaign_id
    LEFT JOIN
        {{ ref('model_stg_customers') }} AS cus
    ON 
        ci.customer_id = cus.customer_id
    LEFT JOIN
        {{ ref('model_stg_orders') }} AS ot
    ON
        ci.customer_id = ot.customer_id
        AND ci.interaction_datetime < ot.order_datetime
        AND ci.order_id != ot.order_id
    WHERE
        c.campaign_type = 'retargeting'
        AND (
            (ci.is_new_customer = FALSE)
            OR (cus.status = 'inactive')
        )
    GROUP BY
        1,
        2
    ORDER BY
        1,
        2
)
SELECT
    *,
    num_recurring_orders > 0 AS is_recurring_customer
FROM
    retargeted_cust_recurring