{{ config(materialized='view') }}

WITH
CTE_ORDER_DURATION AS
(
    SELECT USER_ID
         , COUNT(*) AS ORDER_COUNT
    FROM {{ ref('stg_orders') }}
    GROUP BY USER_ID
)
,
CTE_ORDER_COUNT AS
(
  SELECT ORDER_COUNT
       , COUNT(*) AS USER_COUNT
       , CASE WHEN ORDER_COUNT > 1 THEN TRUE ELSE FALSE END AS REPEAT_USER
  FROM CTE_ORDER_DURATION
  GROUP BY ORDER_COUNT
  ORDER BY ORDER_COUNT
)
,
CTE_DISTINCT_USERS AS
(
  SELECT COUNT(*) AS DISTINCT_USERS
  FROM CTE_ORDER_DURATION
)
,
CTE_REPEAT_USERS AS
(
  SELECT SUM(USER_COUNT) AS REPEAT_USERS
  FROM CTE_ORDER_COUNT
  WHERE REPEAT_USER = TRUE
)
SELECT REPEAT_USERS/DISTINCT_USERS AS REPEAT_RATE
FROM CTE_DISTINCT_USERS
CROSS
JOIN CTE_REPEAT_USERS
