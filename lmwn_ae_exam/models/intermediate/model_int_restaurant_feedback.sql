WITH restaurant_sub_issue_ranked AS(
    SELECT
        restaurant_id,
        issue_sub_type,
        COUNT(1) AS sub_issue_count,
        ROW_NUMBER() OVER (PARTITION BY restaurant_id ORDER BY COUNT(1) DESC) AS sub_issue_rank
    FROM
        {{ ref('model_stg_support_ticket') }}
    WHERE
        issue_type = 'food'
    GROUP BY
        1,
        2
), restaurant_issues AS(
    SELECT
        restaurant_id,
        ARRAY_AGG(issue_sub_type ORDER BY sub_issue_rank DESC) AS issue_raised_ranked
    FROM
        restaurant_sub_issue_ranked
    GROUP BY
        1
), restaurant_aggregated AS(
    SELECT
        restaurant_id,
        COUNT(DISTINCT ticket_id) AS total_tickets,
        COUNT(DISTINCT customer_id) AS total_customers,
        SUM(csat_score) AS total_csat_score,
        AVG(csat_score) AS average_csat_score,
        SUM(DATE_DIFF('minute', ticket_opened_datetime, ticket_resolved_datetime)) AS total_resolution_time_minutes,
        COUNT(DISTINCT CASE WHEN compensation_amount > 0 THEN ticket_id END) AS total_tickets_with_compensation,
        SUM(compensation_amount) AS total_compensation_amount
    FROM
        {{ ref('model_stg_support_ticket') }}
    WHERE
        issue_type = 'food'
    GROUP BY
        1
)
SELECT
    da.*,
    di.issue_raised_ranked
FROM
    restaurant_aggregated AS da
LEFT JOIN
    restaurant_issues AS di
ON
    da.restaurant_id = di.restaurant_id
