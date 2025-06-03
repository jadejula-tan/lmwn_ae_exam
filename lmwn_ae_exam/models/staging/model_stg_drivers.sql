SELECT
    driver_id,
    DATE(join_date) AS join_date,
    vehicle_type,
    region,
    active_status,
    CAST(driver_rating AS DOUBLE) AS driver_rating,
    bonus_tier
FROM
    {{ source('main', 'drivers_master') }}