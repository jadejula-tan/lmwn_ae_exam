SELECT
    ci.*,
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