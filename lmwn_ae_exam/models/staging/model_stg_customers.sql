SELECT
customer_id,
DATE(signup_date) AS signup_date,
customer_segment,
status,
referral_source,
CAST(birth_year AS BIGINT) AS birth_year,
gender,
preferred_device,
FROM
{{ source('main', 'customers_master') }}