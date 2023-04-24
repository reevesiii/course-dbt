{{ config(materialized='table') }}

WITH CTE_DATE_CREATE
AS
(
    SELECT DATEADD(DAY, SEQ4(), '2020-01-01') AS DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 365 * 5))
)
SELECT REPLACE(DATE::DATE::VARCHAR, '-', '')::NUMBER AS DATE_ID
     , DATE::DATE AS DATE
     , DATE::DATE::VARCHAR AS DATE_LABEL
     , DAY(DATE) AS DAY
     , YEAR(DATE) AS YEAR
     , MONTH(DATE) AS MONTH
     , DAY(LAST_DAY(DATE, MONTH)) AS MONTH_DAYS
     , DAYOFWEEK(DATE) AS DAY_OF_WEEK
     , WEEKOFYEAR(DATE) AS WEEK_OF_YEAR
     , DAYOFYEAR(DATE) AS DAY_OF_YEAR
FROM CTE_DATE_CREATE
UNION
SELECT -1 AS DATE_ID
     , NULL AS DATE
     , 'Unknown' AS DATE_LABEL
     , NULL AS DAY
     , NULL AS YEAR
     , NULL AS MONTH
     , NULL AS MONTH_DAYS
     , NULL AS DAY_OF_WEEK
     , NULL AS WEEK_OF_YEAR
     , NULL AS DAY_OF_YEAR
FROM CTE_DATE_CREATE
ORDER BY DATE_ID