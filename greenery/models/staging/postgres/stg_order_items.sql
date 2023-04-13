{{ config(materialized='view') }}

SELECT ORDER_ID
     , PRODUCT_ID
     , QUANTITY
FROM {{ source('postgres', 'ORDER_ITEMS' ) }}
