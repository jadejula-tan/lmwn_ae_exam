SELECT
    CAST(log_id AS BIGINT) AS log_id,
    driver_id,
    incentive_program,
    CAST(bonus_amount AS DOUBLE) AS bonus_amount,
    DATE(applied_date) AS applied_date,
    CAST(delivery_target AS BIGINT) AS delivery_target,
    CAST(actual_deliveries AS BIGINT) AS actual_deliveries,
    CAST(bonus_qualified AS BOOLEAN) AS bonus_qualified,
    region
FROM
    {{ source('main', 'order_log_incentive_sessions_driver_incentive_logs') }}