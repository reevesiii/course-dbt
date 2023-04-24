{{ config(materialized='view') }}

SELECT ORDER_DATE_ID
     , COUNT(DISTINCT ORDER_PK) AS PROMO_ORDERS
     , COUNT(DISTINCT USER_PK) AS PROMO_USERS
FROM {{ ref('fact_orders') }}
WHERE PROMO_PK != SHA2(-1, 512)
GROUP BY ORDER_DATE_ID