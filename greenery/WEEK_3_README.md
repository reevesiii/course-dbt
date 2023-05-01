### Week 3 dbt Project

#### Part 1

**Note:** *Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product*

What is our overall conversion rate?

##### 61%

<details>

```sql 
WITH 
CTE_UNIQUE_SESSIONS_PURCHASE AS 
(
    SELECT COUNT(DISTINCT SESSION_ID) AS UNIQUE_SESSIONS_PURCHASE
    FROM {{ ref('stg_events') }} 
    WHERE EVENT_TYPE = 'checkout'
)
, 
CTE_UNIQUE_SESSIONS AS
(
    SELECT COUNT(DISTINCT SESSION_ID) AS UNIQUE_SESSIONS
    FROM {{ ref('stg_events') }} 
)
SELECT UNIQUE_SESSIONS_PURCHASE/UNIQUE_SESSIONS
FROM CTE_UNIQUE_SESSIONS 
CROSS 
JOIN CTE_UNIQUE_SESSIONS_PURCHASE
```

</details>

What is our conversion rate by product?

| PRODUCT_ID                           | CONVERSION_RATE_SESSION |
|--------------------------------------|-------------------------|
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | 51.3                    |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | 49.3                    |
| 5b50b820-1d0a-4231-9422-75e7f6b0cecf | 41.2                    |
| 55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3 | 43.5                    |
| 579f4cd0-1f45-49d2-af55-9ab2b72c3b35 | 47.5                    |
| c17e63f7-0d28-4a95-8248-b01ea354840e | 45.5                    |
| e5ee99b6-519f-4218-8b41-62f48f59f700 | 38.0                    |
| 5ceddd13-cf00-481f-9285-8340ab95d06d | 42.3                    |
| 58b575f2-2192-4a53-9d21-df9a0c14fc25 | 36.9                    |
| 80eda933-749d-4fc6-91d5-613d29eb126f | 37.8                    |
| e18f33a6-b89a-4fbc-82ad-ccba5bb261cc | 35.9                    |
| 64d39754-03e4-4fa0-b1ea-5f4293315f67 | 44.4                    |
| 05df0866-1a66-41d8-9ed7-e2bbcddd6a3d | 39.7                    |
| a88a23ef-679c-4743-b151-dc7722040d8c | 44.0                    |
| c7050c3b-a898-424d-8d98-ab0aaad7bef4 | 40.5                    |
| bb19d194-e1bd-4358-819e-cd1f1b401c0c | 37.5                    |
| be49171b-9f72-4fc9-bf7a-9a52e259836b | 43.9                    |
| e8b6528e-a830-4d03-a027-473b411c7f02 | 36.7                    |
| 615695d3-8ffd-4850-bcf7-944cf6d3685b | 43.2                    |
| 35550082-a52d-4301-8f06-05b30f6f3616 | 43.1                    |
| e2e78dfc-f25c-4fec-a002-8e280d61a2f2 | 38.2                    |
| d3e228db-8ca5-42ad-bb0a-2148e876cc59 | 43.3                    |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | 48.6                    |
| 6f3a3072-a24d-4d11-9cef-25b0b5f8a4af | 36.8                    |
| 4cda01b9-62e2-46c5-830f-b7f262a58fb1 | 32.3                    |
| e706ab70-b396-4d30-a6b2-a1ccf3625b52 | 44.4                    |
| 843b6553-dc6a-4fc4-bceb-02cd39af0168 | 39.2                    |
| 37e0062f-bd15-4c3e-b272-558a86d90598 | 43.3                    |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | 47.9                    |
| b86ae24b-6f59-47e8-8adc-b17d88cbd367 | 46.6                    |


<details>

```sql 
WITH 
CTE_UNIQUE_SESSIONS_PURCHASE AS 
(
    SELECT PRODUCT_ID
         , SUM(EVENT_TOTAL__CHECKOUT) AS UNIQUE_SESSIONS_PURCHASE
    FROM {{ ref('int_event_types') }} 
    GROUP BY PRODUCT_ID
)
, 
CTE_UNIQUE_SESSIONS AS
(
    SELECT PRODUCT_ID
         , SUM(SESSION_COUNT) AS UNIQUE_SESSIONS
    FROM {{ ref('int_event_types') }} 
    GROUP BY PRODUCT_ID
)
SELECT T1.PRODUCT_ID 
     , (DIV0(SUM(UNIQUE_SESSIONS_PURCHASE),SUM(UNIQUE_SESSIONS)) * 100)::NUMBER(30,1)
FROM CTE_UNIQUE_SESSIONS T1
LEFT
JOIN CTE_UNIQUE_SESSIONS_PURCHASE T2 ON T1.PRODUCT_ID  = T2.PRODUCT_ID 
GROUP BY T1.PRODUCT_ID
```

</details>


#### Part 2: We’re getting really excited about dbt macros after learning more about them and want to apply them to improve our dbt project. 

Used a macro to pivot rows to columns in my intermediate table

#### Part 3: We’re starting to think about granting permissions to our dbt models in our snowflake database so that other roles can have access to them.

added a post-hook to grant permissions

#### Part 4:  After learning about dbt packages, we want to try one out and apply some macros or tests.

done, added file and run `dbt deps`

Install dbt utils and dbt-expectations


#### Part 5: After improving our project with all the things that we have learned about dbt, we want to show off our work!

done

#### Part 6. dbt Snapshots

done

+ Pothos
+ Bamboo
+ Philodendron
+ Monstera
+ String of pearls
+ ZZ Plant