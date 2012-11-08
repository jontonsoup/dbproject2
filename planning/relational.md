# Relational Schema

## The Schema

```
User(id:number, email:string, password:string)

Portfolio(userId:number, id:number)

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
```

