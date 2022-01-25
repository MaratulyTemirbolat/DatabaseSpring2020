create database hotel2;
use hotel2;

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

create table Guest (
	guest_id		int not null unique,
	guest_name		varchar(20) not null,
	guest_surname	varchar(20) not null,
	guest_address   varchar(50) not null,
	date_of_birth   date not null,
	familly_status  varchar(15) not null,
	phone_number    varchar(20) not null unique,
	email           varchar(20) unique,
	payment_type    varchar(10) not null,
	constraint pk_guest_id primary key (guest_id),
);

insert into Guest values
(101, 'Michael',	'West',			'746 Oakwood St. Terre Haute, IN 47802',		'1978-03-28', 'married', '618-907-0603', 'westm28@email.com', 'card'),
(102, 'Jane',		'West',			'746 Oakwood St. Terre Haute, IN 47802',		'1980-04-10', 'married', '618-907-0602', 'westjane28@email.com', 'card'),
(103, 'Anna',		'Browne',		'73 Riverview St.Duarte, CA 91010',				'1980-12-01', 'divorced', '314-525-3971', 'brownea1@email.com', 'card'),
(104, 'Niko',		'Moses',		'380 Vine Drive Mundelein, IL 60060',			'1975-08-13', 'divorced', '847-598-4900', 'mosesn13@email.com', 'card'),
(105, 'Rubie',		'Holding',		'149 Sunnyslope Street Circle Pines, MN 55014', '1999-10-17', 'married', '419-201-7613', 'holdingr17@email.com', 'cash'),
(106, 'Jayson',		'Lyon',			'64 Wood Court Glendale, AZ 85302',				'1985-09-14', 'not married', '641-680-9411', 'lyonj14@email.com', 'cash'),
(107, 'Temirbolat', 'Maratuly',		'Karagandy, Yerzanova 39A',						'2001-01-31', 'not married', '232-231-4353', 't_maratuly@kbtu.kz', 'card'),
(108, 'Yevgeniy',	'Dubinin',		'Almaty, Tole Bi 59',							'2000-12-27', 'divorced', '134-213-5342', 'e_dubinin@kbtu.kz', 'cash'),
(109, 'Nuriman',	'Altybayeva',	'Almaty, Turgut Ozala 27',						'1999-08-23', 'married', '122-412-1553', 'n_altybaeva@kbtu.kz', 'card'),
(110, 'Naruto',		'Uzumaki',		'Almaty, Turgut Ozala 27',						'2001-08-06', 'married', '543-123-2145', 'n_uzumaky@gmail.com', 'cash');

select * from Guest;

create table Guest_Reservation (
	reservation_id	  int not null,
	guest_id		  int not null,
	pet_num           int not null,
	child_num         int not null,
	constraint pk_guest_reservation_res_guest_id primary key (reservation_id, guest_id),
	constraint fk_guest_reservation_res_id foreign key (reservation_id) references Reservation(reservation_id),
	constraint fk_guest_reservation_guest_id foreign key (guest_id) references Guest(guest_id),
);

insert into Guest_Reservation values
(1, 101, 0, 0),
(1, 102, 0, 0),
(2, 103, 0, 1),
(3, 104, 0, 2),
(4, 105, 1, 0),
(5, 106, 1, 0),
(6, 107, 0, 0),
(7, 108, 0, 0),
(8, 109, 0, 0),
(8, 110, 1, 0);

select * from Guest_Reservation;

create table Rating (
	rating_id				int not null,
	rating_guest_id			int not null,
	rating_reservation_id	int not null,
	rating_room				real not null,
	rating_food				real,
	rating_staff			real not null,
	rating_date				date not null,
	rating_total			real not null,
	rating_note				varchar(100),
	constraint pk_rating_id primary key (rating_id),
	constraint fk_rating_reservation_id foreign key (rating_reservation_id) references Reservation(reservation_id),
	constraint fk_rating_guest_id foreign key (rating_guest_id) references Guest(guest_id),
);

insert into Rating values
(1, 101, 1, 5,   4.5,  4.6, '2021-03-14', 4.7,  'food wasn`t warm enough'),
(2, 102, 1, 4.9, 4.3,  5,   '2021-03-03', 4.73, 'A hair was found in  my tomato soup'),
(3, 103, 2, 3.5, 4.6,  4.5, '2021-03-12', 4.2,  'The room furniture was too bad qaulity'),
(4, 104, 3, 4.6, 4,    5,   '2021-01-31', 4.53, 'The play room is very convenient for children'),
(5, 105, 4, 4.7, null, 4.9, '2021-01-20', 4.8,  'The bathroom was too big and comfortable'),
(6, 106, 5, 4.5, null, 4.6, '2021-02-23', 4.55, 'Television doesn`t have many various channels');

select * from Rating;

create table department(
	department_id int constraint pk_department_id primary key,
	department_name varchar(25) unique not null,
	department_floor int not null);

insert into department values
(111,	'Front Ofiice',	1),
(222,	'Housekeeping',	1),
(333,	'Security',	1),
(444,	'Food Production',	1),
(555,	'HR',	1),
(666,	'IT',	1),
(777,	'SPA',	1),
(888,	'Gym',	-1);

select * from department;

create table hotel_staff(
	hotel_staff_id int constraint pk_hotel_staff_id primary key,
	hotel_staff_name varchar(20) not null,
	hotel_staff_surname varchar(20) not null,
	hotel_staff_department_id int constraint fk_hotel_staff_dep_id foreign key references department(department_id),
	hotel_staff_job_title varchar(15) not null,
	hotel_staff_salary int not null,
	hotel_staff_email varchar(20) unique,
	hotel_staff_phone_number varchar(20) not null unique,
	hotel_staff_address varchar(70) not null,
	hotel_staff_joining_date date not null,
	hotel_staff_work_floor int not null);

insert into hotel_staff values
(1,	'Edwin', 	'Schwartz',	111,	'Receptionist',	2000,	'eschawartz@gmail.com',	'505-466-8844',	'8429 Monroe Ave.Reston, VA 20191 Mcminnville, TN 37110',	'2018-06-04',	1),
(2,	'Donnie', 	'Tate',	222,	'Ñleaner',	1000,	'dontate@gmail.com',	'541-938-8185',	'8422 Squaw Creek Street Mcminnville, TN 37110',	'2019-11-24',	2),
(3,	'Braden',	'Winter',	333,	'Guard',	1500,	'bwinder@gmail.com',	'510-417-7421',	'65 Edgewater Drive Elizabeth City, NC 27909',	'2018-01-11',	1),
(4,	'Kofi', 	'Partridge',	555,	'HR Manager',	2500,	'kpartridge@gmail.com',	'509-474-4490',	'7639 North Riverview St.Urbandale, IA 50322',	'2019-12-08',	-2),
(5,	'Anna',	'Smyth',	666,	'DBA',	3000,	'asmyth@gmail.com',	'501-859-2090',	'9842 Berkshire St.	Jenison, MI 49428',	'2020-02-09',	-2),
(6,	'Olga',	'Tate',	222,	'Ñleaner',	1000,	'otate@gmail.com',	'123-234-1242',	'8422 Squaw Creek Street Mcminnville, TN 37110',	'2020-11-10',	3),
(7,	'Deril',	'Tate',	222,	'Ñleaner',	1000,	'dtate@gmail.com',	'124-512-4331',	'8422 Squaw Creek Street Mcminnville, TN 37110',	'2020-01-24',	4),
(8,	'Eduard',	'Tate',	222,	'Ñleaner',	1000,	'etate@gmail.com',	'123-432-1253',	'8422 Squaw Creek Street Mcminnville, TN 37110',	'2020-01-31',	5);

select * from hotel_staff;

create table Hotel_Invoice (
	hotel_invoice_id				int not null,
	hotel_invoice_reservation_id	int not null,
	hotel_invoice_guest_id			int not null,
	hotel_invoice_staff_id			int not null,
	hotel_invoice_total_cost		int not null,
	hotel_invoice_date              date not null,
	constraint pk_hotel_invoice_id primary key (hotel_invoice_id),
	constraint fk_hotel_invoice_reservation_id foreign key (hotel_invoice_reservation_id) references Reservation(reservation_id),
	constraint fk_hotel_invoice_guest_id foreign key (hotel_invoice_guest_id) references Guest(guest_id),
	constraint fk_hotel_invoice_staff_id foreign key (hotel_invoice_staff_id) references Hotel_Staff(hotel_staff_id),
);

insert into Hotel_Invoice values
(1, 1, 101, 8, 50,    '26.04.2021'),
(2, 1, 102, 2, 10,    '27.04.2021'),
(3, 1, 101, 1, 50000, '10.05.2021'),
(4, 2, 104, 7, 20,    '08.05.2021'),
(5, 3, 105, 8, 15,    '10.05.2021'),
(6, 4, 106, 6, 20,    '11.05.2021'),
(7, 5, 106, 2, 35,    '12.05.2021');

select * from Hotel_Invoice;

create table firm(
	firm_id varchar(5) constraint pk_firm_id primary key,
	firm_name varchar(20) unique not null,
	firm_department_id int constraint fk_firm_department_id foreign key references department(department_id),
	firm_floor int  not null,
	firm_seat_number int not null,
	firm_start_date time not null,
	firm_end_time time not null);

insert into firm values
('G1',	'Superman',	888,	-1,	30,	'9:00',	'20:00'),
('SPA1',	'Hawaii',	777,	-1,	20, '10:00','19:00'),
('R1',	'Del Mare',	444,	1,	50,	'7:00',	'22:00'),
('R2',	'Burabai',	444,	1,	60,	'8:00',	'23:00');

select * from firm;

create table firm_staff(
	firm_staff_id int constraint pk_firm_staff_id primary key,
	firm_id varchar(5) constraint fk_firm_staff_firm_id foreign key references firm(firm_id),
	firm_staff_name varchar(20) not null,
	firm_staff_surname varchar(20) not null,
	firm_staff_job_title varchar(15) not null,
	firm_staff_salary int not null,
	firm_staff_email varchar(20) unique,
	firm_staff_phone_number varchar(20) unique not null,
	firm_staff_address varchar(70) not null,
	firm_joining_date date not null);

insert into firm_staff values
(101,	'G1',	'Sam',	'Smith',	'Coach',	3500,	'ssmith@gmail.com',	'504-546-4812',	'25 Brook Ave. Randolph, MA 02368',	'11.11.2020'),
(102,	'SPA1',	'Mary',	'Lee',	'Masseur',	3000,	'mlee@gmail.com',	'501-564-9565',	'7907 Miller Ave. Danvers, MA 01923',	'31.10.2019'),
(100,	'R1',	'Wiktor',	'Mccabe',	'chef',	5000,	'wmccabe@gmail.com',	'123-123-1234',	'903 Creekside Avenue Hastings','21.12.2020'),
(112,	'R1',	'Sofia',	'Ashley',	'waiter',	2500,	'sachley@gmail.com',	'321-321-3211',	'MN 55033, 180 Glen Eagles Dr.Ottumwa',	'12.12.2019'),
(123,	'R1',	'Emilio',	'Mccann',	'waiter',	2500,	'emccann@gmail.com',	'228-228-2288',	'IA 52501, 7209 Randall Mill Dr.Ypsilanti, MI 48197', '22.05.2020'),
(200,	'R2',	'Garry',	'Simon',	'chef',	5000,	'gsimon@gmail.com',	'987-987-9876',	'7825 Wellington Road Longwood',	'29.01.2020'),
(222,	'R2',	'Bred',	'Steele',	'waiter',   2500,	'bsteele@gmail.com',	'654-654-6543',	'FL 32779, 9142 Logan Court Rock Hill',	'15.02.2019'),
(212,	'R2',	'Kate',	'Daly',	'waiter',	2500,	'kdaly@gmail.com',	'213-213-2133',	'9780 Marshall St. Oak Park, MI 48237',	'11.02.2021');

select * from firm_staff;

create table Firm_Invoice (
	firm_invoice_id				int not null,
	firm_invoice_reservation_id	int not null,
	firm_invoice_guest_id		int not null,
	firm_invoice_staff_id		int not null,
	firm_invoice_total_cost		int not null,
	firm_invoice_date           date not null,
	constraint fk_firm_invoice_id primary key (firm_invoice_id),
	constraint fk_firm_invoice_reservation_id foreign key (firm_invoice_reservation_id) references Reservation(reservation_id),
	constraint fk_firm_invoice_guest_id foreign key (firm_invoice_guest_id) references Guest(guest_id),
	constraint fk_firm_invoice_staff_id foreign key (firm_invoice_staff_id) references Firm_Staff(firm_staff_id),
);

insert into Firm_Invoice values
(1, 1, 101, 123, 50, '26.04.2021'),
(2, 1, 102, 123, 10, '27.04.2021'),
(3, 1, 101, 102, 25, '10.05.2021'),
(4, 2, 103, 101, 20, '08.05.2021'),
(5, 3, 104, 102, 15, '10.05.2021'),
(6, 4, 105, 101, 20, '11.05.2021'),
(7, 5, 106, 222, 72, '12.05.2021');

select * from Firm_Invoice;

create table food(
	food_id varchar(7) constraint pk_food_id primary key, 
	food_type varchar(10) not null,
	food_description varchar(70) not null);

insert into food values('f10', 'drink', 'Green Apple alcoholic cocktail'),
						('f11', 'drink', 'Watermelon Glory non-alcoholic cocktail'),
						('f12', 'drink', 'Il Valentino alcoholic coctail'),
						('f13', 'drink', 'Green tea Infuso'),
						('f14', 'bread', 'Fluffy coconut breads'),
						('f15',	'pasta', 'Courgette carbonara'),
						('f16',	'pasta', 'Summer tagliatelle'),
						('f17',	'pasta', 'Honeymoon spaghetti'),
						('f18', 'salad', 'Angry bean salad'),
						('f19',	'salad', 'Mixed leaf salad with mozzarella, mint, peach & prosciutto'),
						('f115', 'salad', 'Smoked trout, horseradish & new potato salad'),
						('f116', 'soup', 'Minestrone soup'),
						('f120', 'soup', 'Chicken & black bean chowder'),
						('f104', 'soup', 'Tomato soup'),
						('f123', 'risotto', 'Freezer-raid springtime risotto'),
						('f147', 'risotto', 'Roasted tomato risotto'),
						('f140', 'fish', 'Pan-fried salmon with watercress sauce'),
						('f150', 'fish', 'Roast haddock with chorizo crust, asparagus and peppers'),
						('f165', 'fish', 'Honey & orange roast sea bass with lentils'),
						('f145', 'cake', 'Lamingtons'),
						('f132', 'cake', 'Bakewell tart'),
						('f131', 'cake', 'Lemon & pistachio cannoli'),
						('f135', 'muffin', 'Chocolate chip muffin'),
						('f20', 'drink', 'Black tea'),
						('f21', 'drink', 'Green tea'),
						('f22', 'drink', 'Apple juice'),
						('f23', 'drink', 'Orange juice'),
						('f24', 'bread', 'Baursak'),
						('f25', 'pasta', 'Fettuccine pasta'),
						('f26', 'meat', 'Kuyrdak'),
						('f27', 'meat', 'Et'),
						('f28',	'meat', 'Steak'),
						('f215', 'salad', 'Cezar salad'),
						('f216', 'salad', 'Summer Asian Slaw'),
						('f220', 'salad', 'Best Broccoli Salad'),
						('f204', 'soup', 'Tomato soup'),
						('f223', 'soup', 'Shorpa'),
						('f247', 'soup', 'Sut Kozhe'),
						('f240', 'fish', 'Baked sea bass with fennel'),
						('f250', 'fish', 'Smoked trout fish pies'),
						('f65',	'cake', 'Tiramisu'),
						('f254', 'muffin', 'Chocolate muffin');

select * from food;

create table restaurant_menu(
	restaurant_id varchar(5) constraint fk_restaurant_menu_restaurant_id foreign key references firm(firm_id),
	food_id varchar(7) constraint fk_restaurant_menu_food_id foreign key references food(food_id),
	cost int not null);

insert into restaurant_menu values('R1', 'f10',	25),
									('R1', 'f11',	15),
									('R1',	'f12',	30),
									('R1',	'f13',	10),
									('R1',  'f14',	15),
									('R1',	'f15',	32),
									('R1',	'f16',	28),
									('R1',	'f17',	25),
									('R1',	'f18',	20),
									('R1',	'f19',	19),
									('R1',	'f115',	18),
									('R1',	'f116',	20),
									('R1',	'f120',	21),
									('R1',	'f104',	23),
									('R1',	'f123',	25),
									('R1',	'f147',	26),
									('R1',	'f140',	25),
									('R1',	'f150',	24),
									('R1',	'f165',	27),
									('R1',	'f145',	15),
									('R1',	'f132',	16),
									('R1',	'f131',	17),
									('R1',	'f135',	10),
									('R2',	'f20',	25),
									('R2',	'f21',	15),
									('R2',	'f22',	30),
									('R2',	'f23',	10),
									('R2',	'f24',	15),
									('R2',	'f25',	32),
									('R2',	'f26',	28),
									('R2',	'f27',	25),
									('R2',	'f28',	20),
									('R2',	'f215',	18),
									('R2',	'f216',	20),
									('R2',	'f220',	21),
									('R2',	'f204',	26),
									('R2',	'f223',	25),
									('R2',	'f247',	24),
									('R2',	'f240',	27),
									('R2',	'f250',	21),
									('R2',	'f65',	14),
									('R2',	'f254',	15);

select * from restaurant_menu;

create table Food_Detail_Invoice (
	firm_invoice_id						int not null,
	food_id								varchar(7) not null,
	food_detail_invoice_restaurant_id	varchar(5) not null,
	food_detail_invoice_date            date not null,
	constraint pk_food_detail_invoice_firm_invoice_id_food_id primary key (firm_invoice_id, food_id),
	constraint fk_food_detail_invoice_restaurant_id foreign key (food_detail_invoice_restaurant_id) references Firm(firm_id),
	constraint fk_food_detail_invoice_food_id foreign key (food_id) references Food(food_id),
	constraint fk_food_detail_invoice_firm_invoice_id foreign key (firm_invoice_id) references firm_invoice(firm_invoice_id),
);

insert into Food_Detail_Invoice values
(1, 'f12',  'R1', '26.04.2021'),
(1, 'f18',  'R1', '26.04.2021'),
(2, 'f13',  'R1', '27.04.2021'),
(7, 'f254', 'R2', '12.05.2021'),
(7, 'f223', 'R2', '12.05.2021'),
(7, 'f25',  'R2', '12.05.2021');

select * from Food_Detail_Invoice;

/* Queries */
/* Display guests' names, surnames, type of room and room rating */
select g.guest_id, g.guest_name, g.guest_surname, room.room_type, Rating.rating_room from
Guest g
join Guest_Reservation g_r on g.guest_id = g_r.guest_id
join Reservation r on g_r.reservation_id = r.reservation_id
join Room on r.reservation_room_id = Room.room_id
join Rating on g.guest_id = Rating.rating_guest_id
order by Rating.rating_room;

/* Display guests's names, surnames, cost, type, name of food */
select g.guest_id, g.guest_name, g.guest_surname, f.food_type, f.food_description, r_m.cost, f_i.firm_invoice_total_cost  from
Guest g
join Firm_Invoice f_i on g.guest_id = f_i.firm_invoice_guest_id
join Food_Detail_Invoice f_d_i on f_i.firm_invoice_id = f_d_i.firm_invoice_id
join Food f on f_d_i.food_id = f.food_id
join restaurant_menu r_m on f.food_id = r_m.food_id;

/* Display how many guests lived in the different types of rooms*/
select count(g_r.guest_id) as guest_number, room.room_type from
	(select g_r.guest_id, r.reservation_room_id
	from Guest_Reservation as g_r
	left join RESERVATION as r
	on r.reservation_id = g_r.reservation_id) as g_r
left join room
on room.room_id = g_r.reservation_room_id
group by room.room_type;

/*Display names of guests, who ordered drinks*/
select g.guest_name, g.guest_surname from 	
	(select distinct g_r.guest_id from
		(select food.food_type,	n.firm_invoice_reservation_id from 
			(select f_inv.firm_invoice_reservation_id, food_detail.food_id
			from Firm_Invoice as f_inv
			left join Food_Detail_Invoice as food_detail
			on f_inv.firm_invoice_id = food_detail.firm_invoice_id
			where food_detail.food_id is not null) as n
		left join food
		on food.food_id = n.food_id
		where food.food_type = 'drink') as n
	left join Guest_Reservation as g_r
	on g_r.reservation_id = n.firm_invoice_reservation_id) as n
left join Guest as g
on g.guest_id = n.guest_id;

 /* Display top 3 dishes by guests who are married  group by count*/
select g.guest_id, g.guest_name, g.guest_surname, r_t.room_type, r_t.room_day_cost, datediff(day, r.arrival_date, r.departure_date) as duration, (r_t.room_day_cost * datediff(day, r.arrival_date, r.departure_date)) as Total_cost from
Guest g
join Guest_Reservation g_r on g.guest_id = g_r.guest_id
join Reservation r on g_r.reservation_id = r.reservation_id
join Room on r.reservation_room_id = Room.room_id
join ROOM_TYPE r_t on Room.room_type = r_t.room_type;

/* Display top 3 hotel staff personal by amount of bills  */
select TOP 3 h_s.hotel_staff_name, h_s.hotel_staff_surname, h_s.hotel_staff_job_title, Count(h_i.hotel_invoice_staff_id) as Amount_of_bills  from
hotel_staff h_s
join Hotel_Invoice h_i on h_s.hotel_staff_id = h_i.hotel_invoice_staff_id
group by h_s.hotel_staff_name, h_s.hotel_staff_surname, h_s.hotel_staff_job_title, h_i.hotel_invoice_staff_id
order by Amount_of_bills desc;