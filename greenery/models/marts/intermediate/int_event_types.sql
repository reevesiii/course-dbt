{{ config(materialized='table') }}

WITH
CTE_ORDER_EVENTS AS
(
SELECT T1.EVENT_ID
     , T1.SESSION_ID
     , T1.ORDER_ID
     , COALESCE(T1.PRODUCT_ID, T2.PRODUCT_ID) AS PRODUCT_ID
     , T1.EVENT_TYPE
     , T1.CREATED_AT
FROM {{ ref('stg_events') }} T1
LEFT
JOIN {{ ref('stg_order_items')}} T2 ON T1.ORDER_ID = T2.ORDER_ID
)

SELECT PRODUCT_ID
     , CREATED_AT::DATE AS CREATE_DATE
     , COUNT(DISTINCT SESSION_ID) AS SESSION_COUNT
       {{ case_event_types() }}
FROM CTE_ORDER_EVENTS
GROUP BY PRODUCT_ID
       , CREATE_DATE