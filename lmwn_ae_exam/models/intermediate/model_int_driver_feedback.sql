WITH driver_sub_issue_ranked AS(
    -- Rank sub issues for each driver based on the count of tickets
    SELECT
        driver_id,
        issue_sub_type,
        COUNT(1) AS sub_issue_count,
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY COUNT(1) DESC) AS sub_issue_rank
    FROM
        {{ ref('model_stg_support_ticket') }}
    WHERE
    -- Filter for driver related issues only
        issue_type in ('rider', 'delivery')
    GROUP BY
        1,
        2
), driver_issues AS(
    -- In list form, display the sub issues raised for each driver, ranked from most frequent to least frequent
    SELECT
        driver_id,
        ARRAY_AGG(issue_sub_type ORDER BY sub_issue_rank DESC) AS issue_raised_ranked
    FROM
        driver_sub_issue_ranked
    GROUP BY
        1
), driver_aggregated AS(
    SELECT
        driver_id,
        COUNT(DISTINCT ticket_id) AS total_tickets,
        COUNT(DISTINCT CASE WHEN issue_sub_type = 'rude' THEN ticket_id END) AS count_rude_feedback,
        COUNT(DISTINCT CASE WHEN issue_sub_type = 'no_mask' THEN ticket_id END) AS count_no_mask_feedback,
        SUM(csat_score) AS total_csat_score,
        AVG(csat_score) AS average_csat_score,
        AVG(CASE WHEN issue_sub_type = 'rude' THEN csat_score ELSE NULL END) AS average_csat_score_rude,
        AVG(CASE WHEN issue_sub_type = 'no_mask' THEN csat_score ELSE NULL END) AS average_csat_score_no_mask,
        SUM(DATE_DIFF('minute', ticket_opened_datetime, ticket_resolved_datetime)) AS total_resolution_time_minutes
    FROM
        {{ ref('model_stg_support_ticket') }}
    WHERE
        issue_type in ('rider', 'delivery')
    GROUP BY
        1
)
SELECT
    da.*,
    di.issue_raised_ranked
FROM
    driver_aggregated AS da
LEFT JOIN
    driver_issues AS di
ON
    da.driver_id = di.driver_id
