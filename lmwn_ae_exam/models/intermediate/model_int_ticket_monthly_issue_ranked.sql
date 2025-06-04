SELECT
    STRFTIME(ticket_opened_datetime, '%Y-%m') AS month,
    issue_type,
    COUNT(1) AS issue_count,
    ROW_NUMBER() OVER (PARTITION BY STRFTIME(ticket_opened_datetime, '%Y-%m') ORDER BY COUNT(1) DESC) AS issue_rank
FROM
    {{ ref('model_stg_support_ticket') }}
GROUP BY
    1,
    2