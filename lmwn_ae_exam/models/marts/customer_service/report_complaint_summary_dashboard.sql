SELECT
    tma.month,
    tma.total_tickets,
    tma.total_unresolved_tickets,
    tma.ticket_compensated_tickets,
    tma.total_compensation_amount,
    tma.unresolved_ticket_ratio,
    tma.avg_resolution_time_minutes,
    MAX(CASE WHEN tmir.issue_rank = 1 THEN tmir.issue_type END) AS top_issue_type_1,
    MAX(CASE WHEN tmir.issue_rank = 2 THEN tmir.issue_type END) AS top_issue_type_2,
    MAX(CASE WHEN tmir.issue_rank = 3 THEN tmir.issue_type END) AS top_issue_type_3,
    MAX(CASE WHEN tmsir.sub_issue_rank = 1 THEN tmsir.issue_sub_type END) AS top_sub_issue_type_1,
    MAX(CASE WHEN tmsir.sub_issue_rank = 2 THEN tmsir.issue_sub_type END) AS top_sub_issue_type_2,
    MAX(CASE WHEN tmsir.sub_issue_rank = 3 THEN tmsir.issue_sub_type END) AS top_sub_issue_type_3
FROM
    {{ ref('model_int_ticket_monthly_aggregated') }} AS tma
LEFT JOIN
    {{ ref('model_int_ticket_monthly_issue_ranked') }} AS tmir
ON
    tma.month = tmir.month
    AND tmir.issue_rank <= 3
LEFT JOIN
    {{ ref('model_int_ticket_monthly_sub_issue_ranked') }} AS tmsir
ON
    tma.month = tmsir.month
    AND tmsir.sub_issue_rank <= 3
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7
ORDER BY
    1 DESC