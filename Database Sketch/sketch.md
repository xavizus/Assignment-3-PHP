# Database sketch

# Tables
- users
- balance
- transactions
- userBalanceRelations

## users table
| user_id | username | password |
| ------- | -------- | -------- |
| 1       | stephan  | test123  |
| 2       | Dennis   | test123  |

## balance
| balance_id | balance |
| ---------- | ------- |
| 1          | 20000   |
| 2          | 10000   |
| 3          | 5000    |

##  userBalanceRelation

| id  | user_id | balance_id |
| --- | ------- | ---------- |
| 1   | 1       | 1          |
| 2   | 2       | 2          |