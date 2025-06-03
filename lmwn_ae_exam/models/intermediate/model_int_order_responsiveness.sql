WITH created_orders AS (
    SELECT
        order_id,
        status_datetime AS created_time
    FROM
        {{ ref('model_stg_orders_status_log') }}
    WHERE
        LOWER(status) = 'created'
),
accepted_orders AS (
    SELECT
        order_id,
        status_datetime AS accepted_time
    FROM
        {{ ref('model_stg_orders_status_log') }}
    WHERE
        LOWER(status) = 'accepted'
),
order_acceptance_time AS (
    SELECT
        co.order_id,
        co.created_time,
        ao.accepted_time,
        DATE_DIFF('minute', co.created_time, ao.accepted_time) AS time_to_accept_minutes
    FROM
        created_orders AS co
    INNER JOIN
        accepted_orders AS ao
    ON
        co.order_id = ao.order_id
)
SELECT
    o.*,
    oat.time_to_accept_minutes
FROM
    {{ ref('model_stg_orders') }} AS o
LEFT JOIN
    order_acceptance_time AS oat
ON
    o.order_id = oat.order_id