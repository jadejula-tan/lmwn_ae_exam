WITH campaign_retargeted_aggregated AS (
    SELECT
        campaign_id,
        COUNT(DISTINCT customer_id) AS retargeted_customers,
        COUNT(DISTINCT CASE WHEN is_recurring_customer THEN customer_id END) AS retargeted_customers_with_recurring_orders,
        SUM(total_purchase_amount) AS total_purchase_amount,
        COUNT(DISTINCT CASE WHEN has_order_within_7_days THEN customer_id END) AS retargeted_customers_with_reorder_within_7_days,
        COUNT(DISTINCT CASE WHEN has_order_within_15_days THEN customer_id END) AS retargeted_customers_with_reorder_within_15_days,
        COUNT(DISTINCT CASE WHEN has_order_within_30_days THEN customer_id END) AS retargeted_customers_with_reorder_within_30_days
    FROM
        {{ ref('model_int_campaign_retargeted_customer') }}
    GROUP BY
        1
), campaign_retargeted_return_purchase_aggregated AS(
    SELECT
        campaign_id,
        AVG(day_between_original_and_return_order) AS avg_day_between_original_and_return_order
    FROM
        {{ ref('model_int_campaign_retargeted_customer_return_purchase') }}
    GROUP BY
        1
)
SELECT
    cm.campaign_id,
    cm.campaign_name,
    cm.campaign_objective,
    cm.targeting_strategy,
    cra.retargeted_customers,
    cra.retargeted_customers_with_recurring_orders,
    cra.retargeted_customers_with_recurring_orders / cra.retargeted_customers AS return_to_recurring_customer_ratio,
    cra.total_purchase_amount,
    cra.retargeted_customers_with_reorder_within_7_days,
    cra.retargeted_customers_with_reorder_within_15_days,
    cra.retargeted_customers_with_reorder_within_30_days,
    crrpa.avg_day_between_original_and_return_order
FROM
    {{ ref('model_stg_campaigns') }} AS cm
LEFT JOIN
    campaign_retargeted_aggregated AS cra
ON
    cm.campaign_id = cra.campaign_id
LEFT JOIN
    campaign_retargeted_return_purchase_aggregated AS crrpa
ON
    cm.campaign_id = crrpa.campaign_id
WHERE
    cm.campaign_type = 'retargeting'
ORDER BY
    cm.targeting_strategy,
    cm.campaign_id
