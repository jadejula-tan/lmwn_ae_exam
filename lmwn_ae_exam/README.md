# Facts about LMWN assignments

Since the datasoures are mocked data, some fields are not given either intentionally or unintentionally. I've made some business assumption to best
meet the require insight metrics.

## Validation
For validation and test, I've imported these two dependecies to use in my project.
- dbt_expectations
- dbt_utils

I've created two new custom generic test under macros/generic_maro.sql
- multi_column_sum
- column_value_not_greater_than_another_col

I added test and validations to the staging models and mart reports, but if given more time, I would add to the intermediate models as well, especially those with multiple upstream reports.

## Improvements I can think of
- better layering
- separate yml schema file for each model when working in a more collaborated project. However, since this is a project only I work on, this style works
- more test both generic and singular to model and columns
