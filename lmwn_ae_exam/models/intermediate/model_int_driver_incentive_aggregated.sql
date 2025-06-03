WITH order_incentive_aggregated AS (
    SELECT
        incentive_program,
        COUNT(DISTINCT driver_id) AS total_drivers,
        COUNT(DISTINCT CASE WHEN bonus_qualified THEN driver_id END) AS bonus_qualified_drivers,
        SUM(bonus_amount) AS total_bonus_amount,
        SUM(CASE WHEN bonus_qualified THEN bonus_amount ELSE 0 END) AS total_bonus_qualified_amount,
        AVG(bonus_amount) AS average_bonus_amount,
        AVG(CASE WHEN bonus_qualified THEN bonus_amount ELSE NULL END) AS average_bonus_qualified_amount
    FROM
        {{ ref('model_stg_driver_incentive_logs') }}
    GROUP BY
        1
)
SELECT
    *,
    bonus_qualified_drivers / NULLIF(total_drivers, 0) AS bonus_qualified_rate
FROM
    order_incentive_aggregated