SELECT
    interaction_id,
    campaign_id,
    customer_id,
    CAST(interaction_datetime AS TIMESTAMP) AS interaction_datetime,
    event_type AS interaction_type,
    platform,
    device_type,
    CAST(ad_cost AS DOUBLE) AS ad_cost,
    order_id,
    CAST(is_new_customer AS BOOLEAN) AS is_new_customer,
    CAST(revenue AS DOUBLE) AS revenue,
    session_id
FROM
{{ source('main', 'campaign_interactions') }}