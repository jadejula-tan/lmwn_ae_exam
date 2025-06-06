-- create generic macro to test sum of multiple columns to be equal to a col
{% test multi_column_sum(model, column_name, multi_col_list) %}
{#
    This macro checks if the sum of multiple columns equals a specified column.

    Params:
        model: The model to apply the test on.
        column_name: The name of the column that should equal the sum of the other columns.
        multi_col_list: A list of columns where sum should equal column_name (our second param).

    Example usage:
    When applying to column 'total_interactions'
    tests:
        - multi_column_sum:
            multi_col_list: [total_clicks, total_impressions, total_conversions]
    
    When appplying to model
    tests:
        - multi_column_sum:
            column_name: total_interactions
            multi_col_list: [total_clicks, total_impressions, total_conversions]
    
#}
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
{#
    This macro checks if a column value is not greater than another model column value.

    Params:
        model: The model to apply the test on.
        column_name: The name of the column expected to have atmost the value of compare_col.
        compare_col: The name of the column expected to have the max value.

    Example usage:
    When applying to column 'total_completed_tasks'
    tests:
        - column_value_not_greater_than_another_col:
            compare_col: total_tasks
    
    When appplying to model
    tests:
        - column_value_not_greater_than_another_col:
            column_name: total_completed_tasks
            compare_col: total_tasks
    
#}
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