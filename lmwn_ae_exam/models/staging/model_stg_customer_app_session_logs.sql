WITH session_logs AS (
    SELECT
        session_id,
        customer_id,
        CAST(session_start AS TIMESTAMP) AS session_start,
        CAST(session_end AS TIMESTAMP) AS session_end,
        device_type,
        CAST(os_version AS DOUBLE) AS os_version,
        app_version,
        location
    FROM
        {{ source('main', 'order_log_incentive_sessions_customer_app_sessions') }}
)
SELECT
    *,
    session_end - session_start AS session_duration
FROM
    session_logs