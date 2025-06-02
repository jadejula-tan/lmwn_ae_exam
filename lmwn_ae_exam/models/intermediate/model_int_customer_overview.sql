WITH customer_campaign_interaction_rn AS(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY interaction_datetime ASC) AS rn
    FROM
        {{ ref('model_int_campaign_interactions_with_details') }}
    WHERE
        is_new_customer = TRUE
), new_customer_campaign_interaction_summary AS(
    {#
        Just to make sure there is only one row which is the first interaction of the customer
    #}
    SELECT
        ccir.customer_id,
        ccir.campaign_id AS first_interacted_campaign_id,
        ccir.interaction_datetime AS first_interacted_datetime,
        ccir.platform AS first_interacted_platform,
        o.order_datetime AS first_order_datetime,
        o.order_datetime - ccir.interaction_datetime AS time_to_first_order,
        sl.session_end - o.order_datetime AS active_time_after_first_order,
    FROM
        customer_campaign_interaction_rn AS ccir
    LEFT JOIN
        {{ ref('model_stg_orders') }} AS o
    ON
        ccir.order_id = o.order_id
    LEFT JOIN
        {{ ref('model_stg_customer_app_session_logs') }} AS sl
    ON
        ccir.session_id = sl.session_id
    WHERE
        rn = 1
), customer_order_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'completed' THEN order_id END) AS completed_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'canceled' THEN order_id END) AS cancelled_orders,
        COUNT(DISTINCT CASE WHEN order_status = 'failed' THEN order_id END) AS failed_orders,
        SUM(total_amount) AS total_purchase_amount,
        SUM(CASE WHEN order_status = 'completed' THEN total_amount ELSE 0 END) AS total_completed_purchased_amount,
        SUM(CASE WHEN order_status = 'canceled' THEN total_amount ELSE 0 END) AS total_cancelled_purchased_amount,
        SUM(CASE WHEN order_status = 'failed' THEN total_amount ELSE 0 END) AS total_failed_purchased_amount,
        AVG(total_amount) AS average_purchased_amount,
        AVG(CASE WHEN order_status = 'completed' THEN total_amount ELSE NULL END) AS average_completed_purchased_amount,
        DATE_DIFF('day', MIN(order_datetime), MAX(order_datetime)) AS day_between_first_and_last_order
    FROM
        {{ ref('model_stg_orders') }}
    GROUP BY
        customer_id
)
SELECT
    c.customer_id,
    c.signup_date,
    c.customer_segment,
    c.status,
    c.referral_source,
    c.birth_year,
    c.gender,
    c.preferred_device,
    cs.total_orders,
    cs.completed_orders,
    cs.completed_orders - 1 AS total_completed_repeat_orders,
    cs.cancelled_orders,
    cs.failed_orders,
    cs.total_purchase_amount,
    cs.total_completed_purchased_amount,
    cs.total_cancelled_purchased_amount,
    cs.total_failed_purchased_amount,
    cs.average_purchased_amount,
    cs.average_completed_purchased_amount,
    cs.day_between_first_and_last_order,
    nccis.first_interacted_campaign_id,
    nccis.first_interacted_datetime,
    nccis.first_interacted_platform,
    nccis.first_order_datetime,
    nccis.time_to_first_order,
    nccis.active_time_after_first_order
FROM
    {{ ref('model_stg_customers') }} AS c
LEFT JOIN
    customer_order_summary AS cs
ON
    c.customer_id = cs.customer_id
LEFT JOIN
    new_customer_campaign_interaction_summary AS nccis
ON
    c.customer_id = nccis.customer_id