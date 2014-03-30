drop schema if exists rnt;

create schema if not exists rnt;

use rnt;

drop table if exists user_basics;

create table if not exists user_basics (
username varchar(20) not null,
pwd varchar(100),
last_name varchar(30),
first_name varchar(20) not null,
middle_name varchar(20),
email varchar(40) not null,
primary key (username),
unique (email)
)
comment = 'Basic info for app users';

insert into user_basics
(username, pwd, last_name, first_name, middle_name, email)
values
('soultrane', 'ilovejazz', 'Coltrane', 'John', 'C', 'soultrane@bluenote.com');

insert into user_basics
(username, pwd, last_name, first_name, middle_name, email)
values
('madmingus', 'basshowlow', 'Mingus', 'Charles', '', 'birdfan@columbia.com');
