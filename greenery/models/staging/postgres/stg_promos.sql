{{ config(materialized='view') }}

SELECT PROMO_ID
     , DISCOUNT
     , STATUS
FROM {{ source('postgres', 'PROMOS' ) }}