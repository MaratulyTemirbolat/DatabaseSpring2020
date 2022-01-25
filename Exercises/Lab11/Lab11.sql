CREATE database usersdb
use usersdb

CREATE TABLE users(
	numberId varchar(5),
	userName varchar(20),
	userSurname varchar(20),
	userType varchar(10),
	userLogin varchar(15)
);
select * from users;
drop table users
insert into users values('1','Temirbolat','Maratuly','admin','t_maratuly');
insert into users values('2','Assanali','Moldash','user','a_moldash');

UPDATE users
SET userName = '',userSurname = ''
where numberId = ''

DELETE FROM users WHERE numberId = '3';