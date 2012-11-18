CREATE TABLE stockuser
(
	email varchar(100) NOT NULL,
	password varchar(50) NOT NULL,
	PRIMARY KEY (email)
);

CREATE TABLE portfolio
(
  id raw(32) NOT NULL,
  email varchar(100) NOT NULL REFERENCES stockuser(email),
  PRIMARY KEY (id)
);

CREATE TABLE stocks
(
	symbol varchar(10) NOT NULL,
	last NUMBER NULL,
	first NUMBER NOT NULL,
	count NUMBER NOT NULL,
	PRIMARY KEY (symbol)
);


CREATE TABLE stocksdaily
(
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol),
	open NUMBER,
	high NUMBER,
	low NUMBER,
	close NUMBER,
	volume NUMBER,
	ts NUMBER,
	PRIMARY KEY (symbol)
);

CREATE TABLE transaction
(
	ts TIMESTAMP DEFAULT systimestamp,
	symbol varchar(10) NOT NULL,
	price NUMBER NOT NULL,
	quantity NUMBER NOT NULL,
	type varchar(10) NOT NULL,
	cashholding NUMBER NOT NULL,
	email varchar(100) NOT NULL,
  portfolio_id raw(32) NOT NULL REFERENCES portfolio(id),
	PRIMARY KEY (ts)
);


CREATE TABLE hastransaction
(
  portfolio_id raw(32) NOT NULL REFERENCES portfolio(id),
	ts TIMESTAMP NOT NULL,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol),
  CONSTRAINT ts_unique UNIQUE (ts)
);

CREATE TABLE hasstock
(
	portfolio_id raw(32) NOT NULL REFERENCES portfolio(id),
	amount NUMBER,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol)
);

create VIEW most_recent_timestamp
as
SELECT symbol, max(ts) as "TS" from stocksdaily group by symbol;

create VIEW most_recent_stockinfo
as 
SELECT * from stocksdaily natural join most_recent_timestamp where close is not null;


create VIEW random_stocks
as 
select * from stocksdaily
  order by dbms_random.value;
                 
