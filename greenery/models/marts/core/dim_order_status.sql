{{ config(materialized='table') }}

SELECT SHA2(STATUS, 512) AS ORDER_STATUS_PK
     , STATUS
FROM {{ ref('stg_orders') }}
WHERE STATUS IS NOT NULL
GROUP BY STATUS
UNION
SELECT SHA2(-1, 512) AS STATUS_PK
     , 'Unknown' AS STATUS