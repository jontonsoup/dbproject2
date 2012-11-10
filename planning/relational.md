# Relational Schema

## The Schema

```
User(id:number, 
     email:string, 
     password:string)

Stock(last:number, 
      first:number, 
      count:number, 
      symbol:string)

StockDaily(stockSymbol:string, 
           open:number, 
           high:number, 
           low:number, 
           close:number, 
           volume: number)

Transaction(timestamp:number, 
            price:number, 
            quantity:number, 
            type:string, 
            cashHolding:number, 
            portfolioId:number, 
            userId:number,
            stockSymbol:string)

HasTransaction(userId:number,
               transactionTimestamp:number,
               stockSymbol:string)

HasStock(userId:number,
         stockSymbol:string,
         amount:number)
```

