# Notes

## To Do

- page: history of transactions DONE
- update DB to allow one or more portfolios
  - change database.sql DONE
  - change queries for new schema DONE
- buy/sell of stocks DONE
- past/future performance DONE
- portfolio stats - doing in stats branch
  - coeff of var and beta for each stock
  - covariance matrix of stocks in portfolio
- strategy eval
- viewing portfolios


## DB changes

- removed cash_holdings from stockuser
- removed portfolio_id from transaction
- removed symbol as primary key from transaction (there could be multiple 
  transactions with the same stock symbol)
- add timestamp (ts) as primary key of transaction
- updated database to support many portfolios to many users
  - portfolio table readded
  - portfolio_id added to transaction
  - timestamp change by Jon
  - hastransaction and hasstock updated
  - file added to drop all tables quickly (drop_tables.sql)

## Useful Queries

### Drop Tables

```
drop table stockuser cascade constraints;
drop table stocks cascade constraints; 
drop table hastransaction;
drop table hasstock;
```

### Show Tables of Given Owner

`select owner, table_name from all_tables where owner='JMF716';`

