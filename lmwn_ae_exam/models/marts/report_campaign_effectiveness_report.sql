SELECT
    cm.campaign_id,
    cm.campaign_name,
    cm.campaign_start_date,
    cm.campaign_end_date,
    cm.campaign_type,
    cm.campaign_objective,
    cm.campaign_channel,
    cm.campaign_budget,
    cm.cost_model,
    cm.targeting_strategy,
    cpd.campaign_interaction_date,
    cpd.total_interactions,
    cpd.total_clicks,
    cpd.total_impressions,
    cpd.total_conversions,
    cpd.average_cost_per_click,
    cpd.average_cost_per_impression,
    cpd.average_cost_per_conversion,
    cpd.average_revenue_per_conversion,
    cpd.total_revenue,
    cpd.total_ad_cost,
    cpd.average_cost_per_new_customer,
    cpd.return_on_ad_spend,
    cpd.average_session_duration,
    cpd.total_customers_with_completed_orders
FROM
    {{ ref('model_stg_campaigns') }} AS cm
LEFT JOIN
    {{ ref('model_int_campaign_performance_daily') }} AS cpd
ON
    cm.campaign_id = cpd.campaign_id
    AND cpd.campaign_interaction_date BETWEEN cm.campaign_start_date AND cm.campaign_end_date
WHERE
    cm.campaign_is_active = TRUE
ORDER BY
    cm.campaign_id,
    cpd.campaign_interaction_date