### How many users do we have?
### 130 Users

<details>

```
SELECT COUNT(*) AS USERS
FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_USERS;
```

</details>

### On average, how many orders do we receive per hour?
### 7.520833 Orders Per Hour

<details>

```
WITH 
CTE_ORDER_COUNT_HOUR AS 
(
    SELECT DATE_TRUNC('HOUR', CREATED_AT) AS CREATED_AT_HOUR
         , COUNT(*) AS ORDER_COUNT
    FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_ORDERS 
    GROUP BY CREATED_AT_HOUR
)
SELECT AVG(ORDER_COUNT) AS ORDERS_PER_HOUR
FROM CTE_ORDER_COUNT_HOUR;
```

</details>

### On average, how long does an order take from being placed to being delivered?
### 3.891803 Days

<details>

```
WITH
CTE_ORDER_DURATION AS 
(
    SELECT DATEDIFF('DAY', CREATED_AT, DELIVERED_AT) AS ORDER_DURATION
    FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_ORDERS 
    WHERE DELIVERED_AT IS NOT NULL
)
SELECT AVG(ORDER_DURATION) ORDER_DURATION
FROM CTE_ORDER_DURATION;
```

</details>

### How many users have only made one purchase? Two purchases? Three+ purchases?
### 

| Order Count | 	User Count |
|:------------|------------:|
| 1           |         	25 |
| 2           |         	28 |
| 3           |         	34 |
| 4           |         	20 |
| 5           |         	10 |
| 6           |          	2 |
| 7           |          	4 |
| 8           |          	1 |

<details>

```
WITH
CTE_ORDER_DURATION AS 
(
    SELECT USER_ID
         , COUNT(*) ORDER_COUNT
    FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_ORDERS 
    GROUP BY USER_ID
)
SELECT ORDER_COUNT
     , COUNT(*) AS USER_COUNT
FROM CTE_ORDER_DURATION
GROUP BY ORDER_COUNT
ORDER BY ORDER_COUNT;
```

</details>

### On average, how many unique sessions do we have per hour?
### 16.327586 Unique Sessions Per Hour

<details>

```
WITH 
CTE_SESSIONS_COUNT_HOUR AS 
(
    SELECT DATE_TRUNC('HOUR', CREATED_AT) AS CREATED_AT_HOUR
         , COUNT(DISTINCT SESSION_ID) AS SESSIONS
    FROM DEV_DB.DBT_REEVESSMITHIIIGMAILCOM.STG_EVENTS
    GROUP BY CREATED_AT_HOUR
)
SELECT AVG(SESSIONS) AS SESSIONS_PER_HOUR
FROM CTE_SESSIONS_COUNT_HOUR;
```

</details>