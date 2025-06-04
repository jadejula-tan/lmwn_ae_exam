SELECT
    STRFTIME(ticket_opened_datetime, '%Y-%m') AS month,
    issue_sub_type,
    COUNT(1) AS sub_issue_count,
    ROW_NUMBER() OVER (PARTITION BY STRFTIME(ticket_opened_datetime, '%Y-%m') ORDER BY COUNT(1) DESC) AS sub_issue_rank
FROM
    {{ ref('model_stg_support_ticket') }}
GROUP BY
    1,
    2