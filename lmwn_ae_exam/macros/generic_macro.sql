-- create generic macro to test sum of multiple columns to be equal to a col
{% test multi_column_sum(model, column_name, multi_col_list) %}
WITH column_sums AS (
    SELECT
        {{ column_name }} AS total_sum,
        {{ multi_col_list | join('+') }} AS calculated_sum
    FROM
        {{ model }}
)
SELECT
    *
FROM
    column_sums
WHERE
    total_sum != calculated_sum
{% endtest %}

{% test column_value_not_greater_than_another_col(model, column_name, compare_col) %}
WITH column_sums AS (
    SELECT
        {{ column_name }} <= {{ compare_col }} AS is_valid
    FROM
        {{ model }}
)
SELECT
    *
FROM
    column_sums
WHERE
    is_valid = FALSE
{% endtest %}