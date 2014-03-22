create schema if not exists rnt;

create table if not exists user_basics (
username varchar(20),
pwd varchar(100),
last_name varchar(30),
first_name varchar(20),
middle_name varchar(20),
email varchar(40)
)
comment = 'Basic info for app users';
