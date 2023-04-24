{{ config(materialized='table') }}

SELECT SHA2(EVENT_TYPE, 512) AS EVENT_TYPE_PK
     , EVENT_TYPE
FROM {{ ref('stg_events') }}
GROUP BY EVENT_TYPE
UNION
SELECT SHA2(-1, 512) AS EVENT_TYPE_PK
     , 'Unknown' AS EVENT_TYPE

