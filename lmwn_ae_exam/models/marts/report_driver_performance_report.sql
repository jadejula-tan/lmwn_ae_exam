SELECT
    d.driver_id,
    d.vehicle_type,
    d.region,
    dp.total_tasks,
    dp.total_completed_tasks,
    dp.late_completed_tasks,
    dp.avg_delivery_minutes,
    dp.avg_time_to_accept_minutes,
    dp.completion_rate,
    dp.late_completion_rate,
    df.total_tickets,
    df.count_rude_feedback,
    df.count_no_mask_feedback,
    df.average_csat_score,
    df.average_csat_score_rude,
    df.average_csat_score_no_mask
FROM
    {{ ref('model_stg_drivers') }} AS d
LEFT JOIN
    {{ ref('model_int_driver_performance') }} AS dp
ON
    d.driver_id = dp.driver_id
LEFT JOIN
    {{ ref('model_int_driver_feedback') }} AS df
ON
    d.driver_id = df.driver_id