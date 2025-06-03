SELECT
    orsp.*,
    DATE_DIFF('minutes', orsp.pickup_datetime, orsp.delivery_datetime) AS delivery_time_minutes,
    di.incentive_program AS incentive_program
FROM
    {{ ref('model_int_order_responsiveness') }} AS orsp
LEFT JOIN
    {{ ref('model_stg_driver_incentive_logs') }} AS di
ON
    orsp.driver_id = di.driver_id
    AND DATE(orsp.order_datetime) = di.applied_date