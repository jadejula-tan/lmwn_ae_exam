SELECT
    log_id,
    order_id,
    status,
    CAST(status_datetime AS TIMESTAMP) AS status_datetime,
    updated_by
FROM
    {{ source('main', 'order_log_incentive_sessions_order_status_logs') }}