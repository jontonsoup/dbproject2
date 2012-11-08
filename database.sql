CREATE TABLE user
(
	id int NOT NULL AUTO_INCREMENT,
	email varchar(100) NOT NULL,
	password varchar(50) NOT NULL,
	PRIMARY KEY (id)
);


CREATE TABLE portfolio
(
	id int NOT NULL AUTO_INCREMENT,
	user_id int NOT NULL,
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
	symbol varchar(10) NOT NULL,
	open NUMBER NOT NULL,
	high NUMBER NOT NULL,
	low NUMBER NOT NULL,
	close NUMBER NOT NULL,
	volume NUMBER NOT NULL,
	PRIMARY KEY (symbol)
);

CREATE TABLE transaction
(
	symbol varchar(10) NOT NULL,
	price NUMBER NOT NULL,
	quantity NUMBER NOT NULL,
	type varchar(10) NOT NULL,
	cashholding NUMBER NOT NULL,
	portfolio_id NUMBER NOT NULL,
	user_id NUMBER NOT NULL,
	PRIMARY KEY (symbol)
);