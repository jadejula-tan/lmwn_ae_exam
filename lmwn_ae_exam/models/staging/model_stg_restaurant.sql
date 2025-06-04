SELECT
    restaurant_id,
    name AS restaurant_name,
    category,
    city,
    CAST(average_rating AS DOUBLE) AS average_rating,
    active_status,
    CAST(prep_time_min AS BIGINT) AS prep_time_min
FROM
    {{ source('main', 'restaurants_master') }}