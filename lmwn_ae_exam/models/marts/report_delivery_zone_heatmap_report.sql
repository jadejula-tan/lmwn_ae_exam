SELECT
    dza.region,
    dza.total_drivers,
    dza.total_active_drivers,
    dzo.total_orders,
    dzo.total_completed_orders,
    dzo.total_cancelled_orders,
    dzo.total_late_deliveries,
    dzo.avg_delivery_time_minutes,
    dzo.avg_delivery_distance_km,
    dzo.completion_rate,
    dzo.cancellation_rate,
    dzo.late_delivery_rate,
    dza.total_active_drivers / NULLIF(dzo.total_orders,0) AS supply_demand_ratio
FROM
    {{ ref('model_int_driver_zone_aggregated') }} AS dza
LEFT JOIN -- Can be changed to INNER JOIN if we want only regions with delivery zones metrics
    {{ ref('model_int_delivery_zone_overview') }} AS dzo
ON
    dza.region = dzo.delivery_zone