create database hotel;
use hotel;

create table ROOM_TYPE(
	room_type varchar(15) constraint pk_room_types PRIMARY KEY,
	room_bed_number integer not NULL,
	room_max_capacity integer not NULL,
	room_balcony_number integer not NULL,
	room_inventory_quality integer not NULL,
	room_day_cost integer not NULL,
	constraint min_inventory_quality CHECK(room_inventory_quality >=1),
	constraint max_inventory_quality CHECK(room_inventory_quality <=3),
	constraint positive_cost CHECK(room_day_cost >0),
	constraint min_balcony_number CHECK(room_balcony_number >= 0),
	constraint max_balcony_number CHECK(room_balcony_number <3),
	constraint min_bed_number CHECK(room_bed_number > 0)
);
insert into ROOM_TYPE values ('president',5,10,2,3,5000);
insert into ROOM_TYPE values ('single',1,1,0,1,100);
insert into ROOM_TYPE values ('family',4,5,1,2,300);
insert into ROOM_TYPE values ('double',1,2,1,2,200);

create table ROOM_OPTION(
	room_type varchar(15) not NULL,
	r_option varchar(20) not NULL,
	constraint fk_room_type FOREIGN KEY(room_type) REFERENCES ROOM_TYPE(room_type),
	constraint pk_roop_otion PRIMARY KEY(room_type,r_option)
);
insert into ROOM_OPTION values('president','pool');
insert into ROOM_OPTION values('president','jacuzzi');
insert into ROOM_OPTION values('president','billiards');
insert into ROOM_OPTION values('president','sauna');
insert into ROOM_OPTION values('family','play room');
insert into ROOM_OPTION values('family','big bathroom');
insert into ROOM_OPTION values('double','big bathroom');

create table INVENTORY(
	inventory_code varchar(7) constraint pk_inventory PRIMARY KEY,
	inventory_description varchar(20) not NULL
);
insert into INVENTORY values('s','sofa');
insert into INVENTORY values('ac','armchair');
insert into INVENTORY values('hd','hairdryer');
insert into INVENTORY values('db','double bed');
insert into INVENTORY values('d','desk');
insert into inventory values('mb','minibar');
insert into INVENTORY values('c','chair');
insert into INVENTORY values('tv','television');
insert into INVENTORY values('cn','conditioner');
insert into INVENTORY values('cs','closet');
insert into INVENTORY values('t','teapot');
insert into INVENTORY values('sb','single bed');

create table ROOM_INVENTORY(
	room_type varchar(15) not NULL,
	inventory_code varchar(7) not NULL,
	room_inventory_quantity integer not NULL,
	constraint fk_room_type_room_inventory FOREIGN KEY(room_type) REFERENCES ROOM_TYPE(room_type),
	constraint fk_inventory_code_room_inventory FOREIGN KEY(inventory_code) REFERENCES INVENTORY(inventory_code),
	constraint pk_room_inventory PRIMARY KEY(room_type,inventory_code)
);
insert into ROOM_INVENTORY values('president','s',2);
insert into ROOM_INVENTORY values('president','ac',5);
insert into ROOM_INVENTORY values('president','hd',3);
insert into ROOM_INVENTORY values('president','db',5);
insert into ROOM_INVENTORY values('president','d',2);
insert into ROOM_INVENTORY values('president','mb',1);
insert into ROOM_INVENTORY values('president','c',10);
insert into ROOM_INVENTORY values('president','tv',3);
insert into ROOM_INVENTORY values('president','cn',2);
insert into ROOM_INVENTORY values('president','cs',4);
insert into ROOM_INVENTORY values('president','t',2);
insert into ROOM_INVENTORY values('single','ac',1);
insert into ROOM_INVENTORY values('single','hd',1);
insert into ROOM_INVENTORY values('single','sb',1);
insert into ROOM_INVENTORY values('single','mb',1);
insert into ROOM_INVENTORY values('single','c',1);
insert into ROOM_INVENTORY values('single','cn',1);
insert into ROOM_INVENTORY values('single','cs',1);
insert into ROOM_INVENTORY values('single','t',1);
insert into ROOM_INVENTORY values('family','s',1);
insert into ROOM_INVENTORY values('family','ac',4);
insert into ROOM_INVENTORY values('family','hd',1);
insert into ROOM_INVENTORY values('family','db',1);
insert into ROOM_INVENTORY values('family','mb',1);
insert into ROOM_INVENTORY values('family','c',5);
insert into ROOM_INVENTORY values('family','tv',1);
insert into ROOM_INVENTORY values('family','cn',1);
insert into ROOM_INVENTORY values('family','cs',3);
insert into ROOM_INVENTORY values('family','t',1);
insert into ROOM_INVENTORY values('double','s',1);
insert into ROOM_INVENTORY values('double','ac',2);
insert into ROOM_INVENTORY values('double','hd',1);
insert into ROOM_INVENTORY values('double','db',1);
insert into ROOM_INVENTORY values('double','mb',1);
insert into ROOM_INVENTORY values('double','tv',1);
insert into ROOM_INVENTORY values('double','cn',1);
insert into ROOM_INVENTORY values('double','t',1);

create table ROOM(
	room_id integer constraint pk_room PRIMARY KEY,
	room_type varchar(15) not NULL,
	room_floor integer not NULL,
	constraint fk_room_type_room FOREIGN KEY(room_type) REFERENCES ROOM_TYPE(room_type),
	constraint min_room_floor CHECK(room_floor >=2),
	constraint max_room_floor CHECK(room_floor <=5)
);
insert into ROOM values(500,'president',5);
insert into ROOM values(120,'single',3);
insert into ROOM values(456,'family',4);
insert into ROOM values(202,'double',2);
insert into ROOM values(205,'double',2);
insert into ROOM values(200,'single',2);
insert into ROOM values(130,'single',3);
insert into ROOM values(103,'double',3);

create table RESERVATION(
	reservation_id integer constraint pk_reservation PRIMARY KEY,
	arrival_date date not NULL,
	departure_date date not NULL,
	reservation_room_id integer not NULL,
	reservation_date date not NULL,
	constraint fk_reservation_room_id FOREIGN KEY(reservation_room_id) REFERENCES ROOM(room_id)
);
select * from RESERVATION;
insert into RESERVATION values(1,'2021-04-25','2021-05-05',500,'2021-04-24');
insert into RESERVATION values(2,'2021-05-03','2021-05-10',120,'2021-04-30');
insert into RESERVATION values(3,'2021-05-05','2021-05-16',456,'2021-05-01');
insert into RESERVATION values(4,'2021-05-05','2021-05-19',202,'2021-05-02');
insert into RESERVATION values(5,'2021-05-08','2021-05-17',205,'2021-05-02');
insert into RESERVATION values(6,'2021-05-09','2021-05-18',200,'2021-05-03');
insert into RESERVATION values(7,'2021-05-10','2021-05-19',130,'2021-05-04');
insert into RESERVATION values(8,'2021-05-11','2021-05-20',103,'2021-05-05');
