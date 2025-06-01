SELECT
    campaign_id,
    campaign_name,
    DATE(start_date) AS campaign_start_date,
    DATE(end_date) AS campaign_end_date,
    campaign_type,
    objective AS campaign_objective,
    channel AS campaign_channel,
    CAST(budget AS DOUBLE) AS campaign_budget,
    cost_model,
    targeting_strategy,
    CAST(is_active AS BOOLEAN) AS campaign_is_active,
FROM
    {{ source('main', 'campaign_master') }}