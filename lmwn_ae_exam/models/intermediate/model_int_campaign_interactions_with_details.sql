SELECT
    ci.*,
    o.order_status,
    sl.session_start,
    sl.session_end,
    sl.session_duration,
    sl.device_type AS device_type,
    sl.os_version,
    sl.app_version,
    sl.location
FROM
    {{ ref('model_stg_campaign_interactions') }} AS ci
LEFT JOIN
    {{ ref('model_stg_customer_app_session_logs') }} AS sl
ON
    ci.session_id = sl.session_id
LEFT JOIN
    {{ ref('model_stg_orders') }} AS o
ON
    ci.order_id = o.order_id