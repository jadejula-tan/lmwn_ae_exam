SELECT
    cm.campaign_id,
    cm.campaign_name,
    cpp.platform AS campaign_platform,
    cpp.total_ad_cost,
    cpp.total_new_customers,
    cpp.average_cost_per_new_customer,
    cncb.total_orders,
    cncb.total_completed_repeat_orders,
    cncb.avg_purchase_amount,
    cncb.avg_completed_purchased_amount,
    cncb.avg_time_to_first_order,
    cncb.avg_active_time_after_first_order
FROM
    {{ ref('model_stg_campaigns') }} AS cm
LEFT JOIN
    {{ ref('model_int_campaign_performance_platform') }} AS cpp
ON
    cm.campaign_id = cpp.campaign_id
LEFT JOIN
    {{ ref('model_int_campaign_new_customer_behavior') }} AS cncb
ON
    cm.campaign_id = cncb.first_interacted_campaign_id
    AND cpp.platform = cncb.first_interacted_platform
ORDER BY
    1,
    2