SELECT
    driver_id,
    COUNT(DISTINCT ticket_id) AS total_tickets,
    COUNT(DISTINCT CASE WHEN issue_sub_type = 'rude' THEN ticket_id END) AS count_rude_feedback,
    COUNT(DISTINCT CASE WHEN issue_sub_type = 'no_mask' THEN ticket_id END) AS count_no_mask_feedback,
    AVG(csat_score) AS average_csat_score,
    AVG(CASE WHEN issue_sub_type = 'rude' THEN csat_score ELSE NULL END) AS average_csat_score_rude,
    AVG(CASE WHEN issue_sub_type = 'no_mask' THEN csat_score ELSE NULL END) AS average_csat_score_no_mask
FROM
    {{ ref('model_stg_support_ticket') }}
WHERE
    issue_type = 'rider'
GROUP BY
    1