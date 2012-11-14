# Notes

## To Do

- page: history of transactions

## DB changes

- removed cash_holdings from stockuser
- removed portfolio_id from transaction
- removed symbol as primary key from transaction (there could be multiple 
  transactions with the same stock symbol)
- add timestamp (ts) as primary key of transaction


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

