{#
    The assignment wants to view the trend over different periods. But the period interval was not specified.
    Here, I am using month as the period interval.
#}
WITH ticket_month_aggregated AS (
    SELECT
        STRFTIME(ticket_opened_datetime, '%Y-%m') AS month,
        AVG(DATE_DIFF('minute', ticket_opened_datetime, ticket_resolved_datetime)) AS avg_resolution_time_minutes,
        COUNT(DISTINCT ticket_id) AS total_tickets,
        COUNT(DISTINCT CASE WHEN ticket_status != 'resolved' THEN ticket_id END) AS total_unresolved_tickets,
        COUNT(DISTINCT CASE WHEN compensation_amount > 0 THEN ticket_id END) AS ticket_compensated_tickets,
        SUM(compensation_amount) AS total_compensation_amount
    FROM
        {{ ref('model_stg_support_ticket') }}
    GROUP BY
        1
)
SELECT
    *,
    total_unresolved_tickets / NULLIF(total_tickets, 0) AS unresolved_ticket_ratio
FROM
    ticket_month_aggregated
