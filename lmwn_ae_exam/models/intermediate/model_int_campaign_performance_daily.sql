SELECT
    campaign_id,
    DATE(interaction_datetime) AS campaign_interaction_date,
    COUNT(1) AS total_interactions,
    SUM(CASE WHEN interaction_type = 'click' THEN 1 ELSE 0 END) AS total_clicks,
    SUM(CASE WHEN interaction_type = 'impression' THEN 1 ELSE 0 END) AS total_impressions,
    SUM(CASE WHEN interaction_type = 'conversion' THEN 1 ELSE 0 END) AS total_conversions,
    AVG(CASE WHEN interaction_type = 'click' THEN ad_cost ELSE NULL END) AS average_cost_per_click,
    AVG(CASE WHEN interaction_type = 'impression' THEN ad_cost ELSE NULL END) AS average_cost_per_impression,
    AVG(CASE WHEN interaction_type = 'conversion' THEN ad_cost ELSE NULL END) AS average_cost_per_conversion,
    AVG(CASE WHEN interaction_type = 'conversion' THEN revenue ELSE NULL END) AS average_revenue_per_conversion,
    SUM(revenue) AS total_revenue,
    SUM(ad_cost) AS total_ad_cost,
    SUM(ad_cost) / COUNT(DISTINCT CASE WHEN is_new_customer THEN customer_id END) AS average_cost_per_new_customer,
    SUM(revenue) / SUM(ad_cost) AS return_on_ad_spend,
    AVG(session_duration) AS average_session_duration,
    COUNT(DISTINCT CASE WHEN is_new_customer THEN customer_id END) AS total_new_customers,
    COUNT(DISTINCT CASE WHEN LOWER(order_status) = 'completed' THEN customer_id END) AS total_customers_with_completed_orders
FROM
    {{ ref('model_int_campaign_interactions_with_details') }}
GROUP BY
    1,
    2
