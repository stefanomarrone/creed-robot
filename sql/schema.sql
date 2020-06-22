drop table if exists download;
drop table if exists upload;
drop table if exists inbound;
drop table if exists buffer;
drop table if exists closetmap;
drop table if exists closet;
drop table if exists package;
drop table if exists outbound;
drop table if exists outbox;
drop table if exists drug;
drop table if exists dbuser;
drop table if exists department;
drop table if exists global;
drop table if exists plc_masking;
drop table if exists mails;
drop table if exists dates;
drop table if exists ccs;

-- Global Section
create table global (
	state varchar(40) primary key
);

create table mails (
	processed char(64) primary key
);

create table dates (
	label varchar(20) primary key,
	lasttime timestamp default now(),
	hours integer
);

create table ccs (
	mail varchar(50) primary key
);

-- User Section
create table department (
	id integer primary key,
	description varchar(40),
	priority integer
);

create table dbuser (
	id integer primary key,
	email varchar(80) unique,
	fullname varchar(60),
	badge varchar(40),
	dept integer references department(id)
);

-- Drug Section
create table drug (
	id varchar(20) primary key,
	code varchar(20) unique,
	description varchar(40),
	height real,
	length real,
	depth real,
	gripside integer
);

create table package (
	id integer primary key,
	drug varchar(20) references drug(id),
	batch varchar(20),
	expire date,
	state varchar(10) default 'free'
);

-- Storage Section
create table closet (
	id varchar(4) primary key
);

create table closetmap (
	drug varchar(20) references drug(id),
	closet varchar(4) references closet(id),
	primary key(drug,closet)
);

create table buffer (
	id integer primary key,
	closet varchar(4) references closet(id),
	x_cell real,
	y_cell real
);

create table outbox (
	id varchar(4) primary key,
	label varchar(20)
);

-- Inbound Section
create table inbound (
	id integer primary key,
	document_id integer,
	address varchar(50),
	arrival timestamp,
	upload timestamp,
	toload boolean default True
);

create table upload (
	id integer primary key,
	inbound integer references inbound(id),
	package integer references package(id),
	buffer integer references buffer(id)
);

-- Outbound Section
create table outbound (
	id integer primary key,
	dbuser integer references dbuser(id),
	download timestamp,
	ready timestamp default null,
	withdrawal timestamp default null,
	outbox varchar(4) references outbox(id) default 'NULL'
);

create table download (
	outbound integer references inbound(id),
	package integer references package(id),
	primary key(outbound,package)
);

--- integrity management
create table plc_masking (
	item varchar(4) primary key,
	mask_pos int
);

