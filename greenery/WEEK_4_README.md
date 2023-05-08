### Week 4 dbt Project

#### Part 1. dbt Snapshots

Determine which products had the most fluctuations in inventory? 

Did we have any items go out of stock in the last 3 weeks?

| NAME                           | WEEK 1 | WEEK 2 | WEEK 3 | WEEK 4 | LAST_DIFFERENCE | WAS_OUT_OF_STOCK | 
|--------------------------------|--------|--------|--------|--------|-----------------|------------------|
|Bamboo                          | 56     | 56     | 44     | 23     | 21              | FALSE            |
|Pothos                          | 40     | 20     | 0      | 20     | 20              | TRUE             |
|Monstera                        | 77     | 64     | 50     | 31     | 19              | FALSE            |
|Philodendron                    | 51     | 25     | 15     | 30     | 15              | FALSE            |
|ZZ Plant                        | 89     | 89     | 53     | 41     | 12              | FALSE            |
|String of pearls                | 58     | 10     | 0      | 10     | 10              | TRUE             |

<details>

```sql 
WITH
CTE_SNAPSHOT_WEEK AS 
(
    SELECT DBT_VALID_FROM::DATE AS WEEK_START
         , 'WEEK ' || (ROW_NUMBER() OVER (ORDER BY WEEK_START))::VARCHAR AS WEEK_LABEL
    FROM PRODUCTS_SNAPSHOT
    GROUP BY DBT_VALID_FROM::DATE
)
,
CTE_INVENTORY_WEEK AS 
(
    SELECT T1.NAME
         , T1.INVENTORY
         , T2.WEEK_LABEL
    FROM PRODUCTS_SNAPSHOT T1
    LEFT 
    JOIN CTE_SNAPSHOT_WEEK T2 ON T1.DBT_VALID_FROM::DATE = T2.WEEK_START
)
, 
CTE_PIVOT AS 
(
    SELECT NAME
         , "'WEEK 1'" AS WEEK_1
         , "'WEEK 2'" AS WEEK_2
         , "'WEEK 3'" AS WEEK_3
         , "'WEEK 4'" AS WEEK_4
    FROM CTE_INVENTORY_WEEK
    PIVOT (SUM(INVENTORY) FOR WEEK_LABEL IN ('WEEK 1', 'WEEK 2', 'WEEK 3', 'WEEK 4')) AS T1
    ORDER BY NAME
)
, 
CTE_COMBINE AS 
(
    SELECT NAME
         , WEEK_1
         , COALESCE(WEEK_2, WEEK_1) AS WEEK_2
         , COALESCE(WEEK_3, WEEK_2, WEEK_1) AS WEEK_3
         , COALESCE(WEEK_4, WEEK_3, WEEK_2, WEEK_1) AS WEEK_4
    FROM CTE_PIVOT
)
SELECT NAME
     , WEEK_1
     , WEEK_2
     , WEEK_3
     , WEEK_4
     , ABS(WEEK_4 - WEEK_3) AS LAST_DIFFERENCE 
     , CASE WHEN (WEEK_1 = 0 OR WEEK_2 = 0 OR WEEK_3 = 0 OR WEEK_4 = 0) THEN TRUE ELSE FALSE END AS WAS_OUT_OF_STOCK
FROM CTE_COMBINE
--WHERE LAST_DIFFERENCE != 0 OR WAS_OUT_OF_STOCK = TRUE
ORDER BY LAST_DIFFERENCE DESC, NAME
```
</details>


####  Part 2. Modeling challenge

How are our users moving through the product funnel? 
Which steps in the funnel have largest drop off points?

+ There are a total of 578 sessions with a page view 
+ There are a total of 467 sessions with a page view and added to cart 
+ There are a total of 361 sessions with a page view and added to cart and checkout

+ Page view with added to cart droppoff = 111 (19.20%)
+ Page view with added to cart and checkout = 106 (22.70%)

<details>

```sql 
WITH 
CTE_SESSION AS 
(
    SELECT SESSION_ID
    FROM STG_EVENTS
    GROUP BY SESSION_ID
)
,
CTE_PAGE_VIEW AS 
(
    SELECT SESSION_ID
         , TRUE AS PAGE_VIEW
    FROM STG_EVENTS
    WHERE EVENT_TYPE = 'page_view'
    GROUP BY SESSION_ID
)
,
CTE_ADD_TO_CART AS 
(
    SELECT SESSION_ID
         , TRUE AS ADD_TO_CART
    FROM STG_EVENTS
    WHERE EVENT_TYPE = 'add_to_cart'
    GROUP BY SESSION_ID
)
,
CTE_CHECKOUT AS 
(
    SELECT SESSION_ID
         , TRUE AS CHECKOUT
    FROM STG_EVENTS
    WHERE EVENT_TYPE = 'checkout'
    GROUP BY SESSION_ID
)
,
CTE_FROM_SESSION AS 
(
    SELECT T1.SESSION_ID
         , COALESCE(T2.PAGE_VIEW, FALSE) AS PAGE_VIEW
         , COALESCE(T3.ADD_TO_CART, FALSE) AS ADD_TO_CART
         , COALESCE(T4.CHECKOUT, FALSE) AS CHECKOUT
    FROM CTE_SESSION T1
    LEFT
    JOIN CTE_PAGE_VIEW T2 ON T1.SESSION_ID = T2.SESSION_ID
    LEFT 
    JOIN CTE_ADD_TO_CART T3 ON T1.SESSION_ID = T3.SESSION_ID
    LEFT 
    JOIN CTE_CHECKOUT T4 ON T1.SESSION_ID = T4.SESSION_ID
) 
SELECT COUNT(*)
FROM CTE_FROM_SESSION
WHERE PAGE_VIEW = TRUE
  AND ADD_TO_CART = TRUE
  AND CHECKOUT = TRUE
```

</details>

#### Part 3: Reflection questions

3A. dbt next steps for you 

We have been using dbt and are moving from dbt cloud. We plan to move to dagster for a more robust orchestrator and handle things that are not as easy in dbt like partitioned tables.

3B. Setting up for production / scheduled dbt run of your project

see above. 