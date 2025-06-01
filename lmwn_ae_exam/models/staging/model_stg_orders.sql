SELECT
    order_id,
    customer_id,
    restaurant_id,
    driver_id,
    CAST(order_datetime AS TIMESTAMP) AS order_datetime,
    CAST(pickup_datetime AS TIMESTAMP) AS pickup_datetime,
    CAST(delivery_datetime AS TIMESTAMP) AS delivery_datetime,
    order_status,
    delivery_zone,
    CAST(total_amount AS DOUBLE) AS total_amount,
    payment_method,
    CAST(is_late_delivery AS BOOLEAN) AS is_late_delivery,
    CAST(delivery_distance_km AS DOUBLE) AS delivery_distance_km,
FROM
    {{ source('main', 'order_transactions') }}