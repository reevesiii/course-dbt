{{ config(materialized='table') }}

SELECT SHA2(T1.ORDER_ID, 512) AS ORDER_PK
     , SHA2(T1.USER_ID, 512) AS USER_PK
     , SHA2(T2.PRODUCT_ID, 512) AS PRODUCT_PK
     , REPLACE(T1.CREATED_AT::DATE::VARCHAR, '-', '')::NUMBER AS CREATE_DATE_ID
     , T2.QUANTITY
     , T3.PRICE
FROM {{ ref('stg_orders') }} T1
LEFT
JOIN {{ ref('stg_order_items') }} T2 ON T1.ORDER_ID = T2.ORDER_ID
LEFT
JOIN {{ ref('stg_products') }} T3 ON T2.PRODUCT_ID = T3.PRODUCT_ID