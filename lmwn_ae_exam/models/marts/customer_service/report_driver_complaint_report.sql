SELECT
    d.driver_id,
    df.total_tickets AS issue_count,
    df.issue_raised_ranked,
    df.total_resolution_time_minutes AS total_resolution_minutes,
    df.total_tickets / NULLIF(dp.total_tasks, 0) AS issue_rate,
    d.driver_rating AS rating_before_complaint,
    (d.driver_rating + df.total_csat_score) / (df.total_tickets + 1) AS rating_after_complaint
FROM
    {{ ref('model_stg_drivers') }} AS d
LEFT JOIN
    {{ ref('model_int_driver_feedback') }} AS df
ON
    d.driver_id = df.driver_id
LEFT JOIN
    {{ ref('model_int_driver_performance') }} AS dp
ON
    d.driver_id = dp.driver_id
WHERE
    df.total_tickets IS NOT NULL
    AND d.active_status = 'active'
ORDER BY
    df.total_tickets DESC