SELECT
    ticket_id,
    order_id,
    customer_id,
    driver_id,
    restaurant_id,
    issue_type,
    issue_sub_type,
    channel,
    CAST(opened_datetime AS TIMESTAMP) AS ticket_opened_datetime,
    CAST(resolved_datetime AS TIMESTAMP) AS ticket_resolved_datetime,
    status AS ticket_status,
    CAST(csat_score AS BIGINT) AS csat_score,
    CAST(compensation_amount AS BIGINT) AS compensation_amount,
    resolved_by_agent_id
FROM
    {{ source('main', 'support_tickets') }}