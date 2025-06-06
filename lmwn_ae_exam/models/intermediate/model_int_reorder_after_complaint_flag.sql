WITH restaurant_ticket_aggregated AS (
    -- Rank tickets by customer and restaurant to find the first complaint ticket
    SELECT
        customer_id,
        restaurant_id,
        order_id,
        ticket_opened_datetime,
        ROW_NUMBER() OVER (PARTITION BY customer_id, restaurant_id ORDER BY ticket_opened_datetime ASC) AS ticket_rank
    FROM
        {{ ref('model_stg_support_ticket') }}
    WHERE
        issue_type = 'food'
), customer_first_restaurant_ticket AS(
    -- Filter for the first complaint ticket for each customer and restaurant
    SELECT
        customer_id,
        restaurant_id,
        order_id,
        ticket_opened_datetime,
        ticket_rank
    FROM
        restaurant_ticket_aggregated
    WHERE
        ticket_rank = 1
)
SELECT
    -- Flag recurring orders of the same customer after their first complaint ticket
    o.order_id,
    o.customer_id,
    o.restaurant_id,
    o.order_datetime,
    o.order_status,
    o.total_amount,
    CASE
        WHEN cfrt.order_id IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_reorder_after_complaint
FROM
    {{ ref('model_stg_orders') }} AS o
LEFT JOIN
    customer_first_restaurant_ticket AS cfrt
ON
    o.customer_id = cfrt.customer_id
    AND o.restaurant_id = cfrt.restaurant_id
    AND o.order_id != cfrt.order_id
    AND o.order_datetime > cfrt.ticket_opened_datetime