CREATE TABLE stockuser
(
	email varchar(100) NOT NULL,
	password varchar(50) NOT NULL,
	PRIMARY KEY (email)
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
	PRIMARY KEY (ts)
);


CREATE TABLE hastransaction
(
	email varchar(100) NOT NULL REFERENCES stockuser(email),
	ts TIMESTAMP,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol),
	CONSTRAINT ts_unique UNIQUE (ts)
);

CREATE TABLE hasstock
(
	email varchar(100) NOT NULL REFERENCES stockuser(email),
	amount NUMBER,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol)
);
