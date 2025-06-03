SELECT
    oir.incentive_program,
    dia.total_drivers,
    dia.bonus_qualified_drivers,
    oir.total_orders,
    oir.completed_orders,
    oir.completed_order_rate,
    oir.average_delivery_time_minutes,
    oir.average_time_to_accept_minutes,
    dia.bonus_qualified_rate AS driver_satisfaction_rate,
    dia.average_bonus_qualified_amount,
    dia.average_bonus_qualified_amount / oir.total_completed_order_amount AS bonus_to_revenue_ratio
FROM
    {{ ref('model_int_order_incentive_aggregated') }} AS oir
LEFT JOIN
    {{ ref('model_int_driver_incentive_aggregated') }} AS dia
ON
    oir.incentive_program = dia.incentive_program