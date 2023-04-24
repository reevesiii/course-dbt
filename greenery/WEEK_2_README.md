### What is the repeat rate?
### 0.798387 percent

<details>

```sql 
WITH
CTE_ORDER_COUNT AS
(
    SELECT USER_ID
         , COUNT(*) AS ORDER_COUNT
    --FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_ORDERS
    FROM {{ ref('stg_orders') }}
    GROUP BY USER_ID
)
,
CTE_USER_SPLIT AS
(
  SELECT ORDER_COUNT
       , COUNT(*) AS USER_COUNT
       , CASE WHEN ORDER_COUNT > 1 THEN TRUE ELSE FALSE END AS REPEAT_USER
  FROM CTE_ORDER_COUNT
  GROUP BY ORDER_COUNT
  ORDER BY ORDER_COUNT
)
,
CTE_DISTINCT_USERS AS
(
  SELECT COUNT(*) AS DISTINCT_USERS
  FROM CTE_ORDER_COUNT
)
,
CTE_REPEAT_USERS AS
(
  SELECT SUM(USER_COUNT) AS REPEAT_USERS
  FROM CTE_USER_SPLIT
  WHERE REPEAT_USER = TRUE
)
SELECT REPEAT_USERS/DISTINCT_USERS AS REPEAT_RATE
FROM CTE_DISTINCT_USERS
CROSS
JOIN CTE_REPEAT_USERS
```

</details>

### What are good indicators of a user who will likely purchase again?

#### People that have not purchased the `Money Tree` it should be a big seller. 

### Page View - Questions (that are supported with the fact_page_view table)
+ What are daily page views by product? 
+ Daily orders by product? 
+ What’s getting a lot of traffic, but maybe not converting into purchases?

### Order - Questions (that are supported with the fact_order and fact_order_items table)
+ first order? 
+ Last order? 
+ How many orders have they made? 
+ Total spend?

### Explain the product mart models you added: 

I added the following dimension tables to support the following fact tables

+ dim_address
+ dim_date
+ dim_event_type
+ dim_order_status
+ dim_product
+ dim_promo
+ dim_shipping_service
+ dim_user

The following fact tables support orders and order items as well as page views

+ fact_orders
+ fact_order_items
+ fact_page_views

The tables we picked based on the staging tables and creating a holistic view of the data with dimensions for each categorical item. Some dimensions were added from degeneration dimension in the fact tables. 