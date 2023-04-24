{{ config(materialized='table') }}

SELECT SHA2(ADDRESS_ID, 512) AS ADDRESS_PK
     , ADDRESS
     , ZIPCODE
     , STATE
     , COUNTRY
-- FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_ADDRESSES
FROM {{ ref('stg_addresses') }}
UNION
SELECT SHA2(-1, 512) AS ADDRESS_PK
     , 'Unknown' AS ADDRESS
     , NULL AS ZIPCODE
     , 'Unknown' AS STATE
     , 'Unknown' AS COUNTRY
