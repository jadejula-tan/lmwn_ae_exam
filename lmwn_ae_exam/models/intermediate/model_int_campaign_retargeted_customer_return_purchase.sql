WITH customer_first_order AS (
    -- Find customer's first order datetime
    SELECT
        rc.customer_id,
        MIN(o.order_datetime) AS first_order_datetime
    FROM
        {{ ref('model_int_campaign_retargeted_customer') }} AS rc
    INNER JOIN
            {{ ref('model_stg_orders') }} AS o
    ON
        rc.customer_id = o.customer_id
    GROUP BY
        1
)
SELECT
    -- Find days between the first order and the campaign interaction/return order
    rc.campaign_id,
    rc.customer_id,
    cfo.first_order_datetime,
    DATE_DIFF('day', cfo.first_order_datetime, ci.interaction_datetime) AS day_between_original_and_return_order
FROM
    {{ ref('model_int_campaign_retargeted_customer') }} AS rc
INNER JOIN
    {{ ref('model_int_campaign_interactions_with_details') }} AS ci
ON
    rc.campaign_id = ci.campaign_id
    AND rc.customer_id = ci.customer_id
LEFT JOIN
    customer_first_order AS cfo
ON
    rc.customer_id = cfo.customer_id