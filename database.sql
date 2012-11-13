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
	open NUMBER NOT NULL,
	high NUMBER NOT NULL,
	low NUMBER NOT NULL,
	close NUMBER NOT NULL,
	volume NUMBER NOT NULL,
	PRIMARY KEY (symbol)
);

CREATE TABLE transaction
(
	ts TIMESTAMP DEFAULT systimestamp,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol),
	price NUMBER NOT NULL,
	quantity NUMBER NOT NULL,
	type varchar(10) NOT NULL,
	cashholding NUMBER NOT NULL,
	user_id NUMBER NOT NULL,
	PRIMARY KEY (symbol)
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
	amount NUMBER UNIQUE,
	symbol varchar(10) NOT NULL REFERENCES stocks(symbol)
);
