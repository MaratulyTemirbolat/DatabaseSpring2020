use hotel2;

-- need to add trigger to insert not null values
alter table hotel_staff add gender varchar(6);
alter table hotel_staff add previous_job_title varchar(40);
alter table hotel_staff add previous_workplace varchar(40);
alter table hotel_staff add job_experience int;
alter table hotel_staff add highest_education_level varchar(40);
alter table hotel_staff add speciality varchar(70);
alter table hotel_staff add birthday date;
alter table hotel_staff add start_time time;
alter table hotel_staff add end_time time;

insert into department values (999, 'Administration', 1);
delete from department where department_name = 'HR';

insert into hotel_staff values (9, 'Jake', 'Green', 999, 'Hotel Manager', 2000, 'green_jake@gmail.com', 
								'156-314-1548', '7 Avenue 23', '2019-02-14', 1, 'Male', 'Hotel Manager',
								'New York Hotel', 4, 'Master', 'Hotel Service', '1992-11-12', '10:00', '12:00');

update hotel_staff set birthday = '1980-02-12', gender = 'Male', 
	previous_job_title = 'Receptionist', previous_workplace = 'Rixos Hotel',
	job_experience = 3, speciality = 'Hotel Service', highest_education_level = 'Bachelor',
	start_time = '07:00:00', end_time = '15:00:00'
	where hotel_staff_id = 1;

update hotel_staff 
	set birthday = '1997-09-01', 
	gender = 'Male', 
	previous_job_title = 'Cleaner', 
	previous_workplace = 'Golden Hotel',
	job_experience = 4, 
	speciality = 'Management', 
	highest_education_level = 'Bachelor',
	start_time = '08:00:00', 
	end_time = '17:00:00'
	where hotel_staff_id = 2;

update hotel_staff 
	set birthday = '1980-08-23', 
	gender = 'Male', 
	previous_job_title = 'Guard',
	previous_workplace = 'Golden Hotel',
	job_experience = 3, 
	highest_education_level = 'High School',
	start_time = '08:00:00', 
	end_time = '20:00:00'
	where hotel_staff_id = 3;

update hotel_staff 
	set birthday = '1995-04-30', 
	gender = 'Male', 
	previous_job_title = 'HR Manager',
	previous_workplace = 'Corner Hotel',
	job_experience = 4, 
	speciality = 'Human Resources Management',
	highest_education_level = 'Master',
	start_time = '10:00:00', 
	end_time = '17:00:00'
	where hotel_staff_id = 4;

update hotel_staff 
	set hotel_staff_department_id = 999,
	birthday = '1995-04-30', 
	gender = 'Male', 
	previous_job_title = 'HR Manager',
	previous_workplace = 'Corner Hotel',
	job_experience = 4, 
	speciality = 'Human Resources Management',
	highest_education_level = 'Master',
	start_time = '10:00:00', 
	end_time = '17:00:00'
	where hotel_staff_id = 4;

update hotel_staff 
	set birthday = '1996-12-31', 
	gender = 'Female', 
	previous_job_title = 'DBA',
	previous_workplace = 'Corner Hotel',
	job_experience = 5, 
	speciality = 'Information Systems and Technologies',
	highest_education_level = 'Master',
	start_time = '10:00:00', 
	end_time = '17:00:00'
	where hotel_staff_id = 5;

update hotel_staff 
	set birthday = '1985-05-07', 
	gender = 'Female', 
	previous_job_title = 'Cleaner',
	previous_workplace = 'Asia Pattaya Hotel',
	job_experience = 4, 
	highest_education_level = 'High School',
	start_time = '09:00:00', 
	end_time = '15:00:00'
	where hotel_staff_id = 6;

update hotel_staff set previous_job_title = 'Cleaner', hotel_staff_job_title = 'Cleaner' where previous_job_title = 'Cleaner';

update hotel_staff 
	set birthday = '1980-02-25', 
	gender = 'Male', 
	previous_job_title = 'Cleaner',
	previous_workplace = 'Asia Pattaya Hotel',
	job_experience = 3, 
	speciality = 'Information Systems and Technologies',
	highest_education_level = 'Bachelor',
	start_time = '09:00:00', 
	end_time = '15:00:00'
	where hotel_staff_id = 7;

update hotel_staff 
	set birthday = '1993-06-15', 
	gender = 'Male', 
	previous_job_title = 'Cleaner',
	previous_workplace = 'Kazakhstan Hotel',
	job_experience = 3, 
	highest_education_level = 'High School',
	start_time = '09:00:00', 
	end_time = '15:00:00'
	where hotel_staff_id = 8;

update hotel_staff 
	set birthday = '1992-11-12', 
	gender = 'Male', 
	previous_job_title = 'Hotel Manager',
	previous_workplace = 'New York Hotel',
	job_experience = 4, 
	speciality = 'Hotel Service',
	highest_education_level = 'Master',
	start_time = '10:00:00', 
	end_time = '17:00:00'
	where hotel_staff_id = 9;

create table former_staff(
	hotel_staff_id int primary key,
	hotel_staff_name varchar(20) not null,
	hotel_staff_surname varchar(20) not null,
	hotel_staff_department_id int,
	hotel_staff_job_title varchar(15) not null,
	hotel_staff_salary int not null,
	hotel_staff_email varchar(20),
	hotel_staff_phone_number varchar(20) not null,
	hotel_staff_address varchar(70) not null,
	hotel_staff_joining_date date not null,
	hotel_staff_work_floor int not null,
	gender varchar(6) not null,
	previous_job_title varchar(40) not null,
	previous_workplace varchar(40) not null,
	job_experience int not null,
	highest_education_level varchar(40),
	speciality varchar(70),
	birthday date not null,
	start_time time not null,
	end_time time not null);

create table former_hotel_staff_invoice(
	hotel_invoice_id int not null,
	hotel_invoice_reservation_id int not null,
	hotel_invoice_guest_id int not null,
	hotel_invoice_staff_id int not null,
	hotel_invoice_total_cost int not null,
	hotel_invoice_date date not null)

drop table Rating;
create table Rating (
	rating_id				int not null,
	rating_guest_id			int not null,
	rating_reservation_id	int not null,
	rating_room				real not null,
	rating_food				real,
	rating_staff			real not null,
	rating_date				date,
	rating_total			real,
	rating_note				varchar(100),
	constraint pk_rating_id primary key (rating_id),
	constraint fk_rating_reservation_id foreign key (rating_reservation_id) references Reservation(reservation_id),
	constraint fk_rating_guest_id foreign key (rating_guest_id) references Guest(guest_id),
);

insert into Rating values
(1, 101, 1, 5,   4.5,  4.6, '14.03.2021', 4.7,  'food wasn`t warm enough'),
(2, 102, 1, 4.9, 4.3,  5,   '03.03.2021', 4.73, 'A hair was found in  my tomato soup'),
(3, 103, 2, 3.5, 4.6,  4.5, '12.03.2021', 4.2,  'The room furniture was too bad qaulity'),
(4, 104, 3, 4.6, 4,    5,   '31.01.2021', 4.53, 'The play room is very convenient for children'),
(5, 105, 4, 4.7, null, 4.9, '20.01.2021', 4.8,  'The bathroom was too big and comfortable'),
(6, 106, 5, 4.5, null, 4.6, '23.02.2021', 4.55, 'Television doesn`t have many various channels');


-- 5 procedure
-- 5.1 ADD HERE


-- 5.2
create trigger overtimeBonus
on hotel_staff after update, insert
as begin
declare @salary int, @new_salary int, @work_time int, @staff_id int;
select @work_time = datediff(hour, start_time, end_time), @salary = hotel_staff_salary, @staff_id = hotel_staff_id from inserted;
if (@work_time >= 8)
begin
	set @new_salary = @salary * 1.1;
	update hotel_staff set hotel_staff_salary = @new_salary where hotel_staff_id = @staff_id;
end;
end;

select * from hotel_staff
-- delete from former_staff where 1=1
-- delete from former_hotel_staff_invoice where 1=1
-- Test
/*insert into hotel_staff values (12, 'Will', 'Smith', 999, 'Hotel Manager', 2000, 'wl_smith@gmail.com', 
								'156-314-78', 'v7 Avenue 23', '2019-02-14', 1, 'Male', 'Hotel Manager',
								'New York Hotel', 4, 'Master', 'Hotel Service', '2005-11-12', '10:00', '19:00');
insert into hotel_staff values (13, 'John', 'Cina', 999, 'HR Manager', 2200, 'john_cina@gmail.com', 
								'156-3214-7894', '2035 Red dragon', '2019-02-14', 1, 'Male', 'HR Manager',
								'Almaty Hotel', 4, 'Master', 'Hotel Service', '1999-11-12', '10:00', '17:00');
update hotel_staff set highest_education_level = 'High School' where hotel_staff_id = 13;
update hotel_staff set job_experience = 2 where hotel_staff_id = 8;
insert into hotel_staff values
(8,	'Eduard', 'Tate', 222, 'Cleaner', 1000, 'etate@gmail.com', '123-432-1253', '8422 Squaw Creek Street Mcminnville, TN 37110', '31.01.2020', 5, 'Male', 
'Cleaner', 'Kazakhstan Hotel', 3, 'High School', null, '1993-06-15', '09:00:00', '15:00:00');
insert into Hotel_Invoice values
(1, 1, 101, 8, 50,    '26.04.2021'),
(5, 3, 105, 8, 15,    '10.05.2021');
delete from hotel_staff where hotel_staff_id=13;
*/

-- 6 procedure, authoric, quality management 
-- procedure for hotel manager (he manages customer complaints) 
-- that shows room and staff rating that are less than choosed rating_number and shows res_id, guest_id, room type, all staff, who have provided any service
-- create trigger on total_rating (!)

create function whichRoomAndType(@reserv_id int, @guest_id int)
returns varchar(max)
begin
declare @roomTypeAndNumber varchar(max), @roomNumber int, @roomType varchar(10), @room_rating real;
select @roomNumber = (select reservation_room_id from RESERVATION where reservation_id = @reserv_id);
select @room_rating = (select rating_room from Rating where rating_reservation_id = @reserv_id and rating_guest_id = @guest_id);
select @roomType = (select ROOM_TYPE from ROOM where room_id = @roomNumber);
set @roomTypeAndNumber = 'Room rating: '+trim(convert(varchar(15), @room_rating))+char(10)+'Room type: '+@roomType+', room number: '+trim(convert(varchar(15), @roomNumber))+char(10);
return trim(@roomTypeAndNumber);
end;
--drop function whichRoomAndType
-- 

create function whichStaff(@reserv_id int, @guest_id int)
returns varchar(100)
begin
declare @hotelStaffIds varchar(100), @staff_rating real;
select @staff_rating = (select rating_staff from Rating where rating_reservation_id = @reserv_id and rating_guest_id = @guest_id);
declare @staffTable table(staff_id int,staff_job_title varchar(15));
-- inserting staff is who works on room's floor
insert into @staffTable select h_st.hotel_staff_id as staff_id, h_st.hotel_staff_job_title as staff_job_title
from hotel_staff as h_st
right join (select room.room_floor from room 
		right join RESERVATION as res
		on room.room_id=res.reservation_room_id
		where res.reservation_id = @reserv_id) as n
on h_st.hotel_staff_work_floor = n.room_floor;
-- inserting staff id from hotel invoice
insert into @staffTable select h_in.hotel_invoice_staff_id as staff_id, h_st.hotel_staff_job_title as staff_job_title
		from Hotel_Invoice as h_in
		left join hotel_staff as h_st
		on h_in.hotel_invoice_staff_id = h_st.hotel_staff_id
		where hotel_invoice_reservation_id = @reserv_id and hotel_invoice_guest_id = @guest_id;
select @hotelStaffIds = (select concat('Staff: ', substring((select n.staff_job_title+' with id '+convert(varchar(15), n.staff_id)+', ' AS 'data()' 
FROM @staffTable as n FOR XML PATH('')), 1 , 9999), char(10)));
set @hotelStaffIds = 'Staff rating: '+trim(convert(varchar(15), @staff_rating))+char(10)+@hotelStaffIds;
return trim(@hotelStaffIds);
end;

--print(dbo.whichStaff(1, 102))
create procedure roomAndStaffRating(@res_id int = null, @guest_id int = null, @total_rating real = 5.0, @room_rating real = 5.0, @staff_rating real = 5.0)
as begin
declare @result varchar(max) = '', @row_num int, @n_reserv_id int, @n_guest_id int, @n_rating_id int, @n_note varchar(100), @total_r real;
declare @ratings table(rating_id int, res_id int, guest_id int, rating_note	varchar(100), rating_total real);
if (@total_r > 5 or @room_rating > 5 or @staff_rating > 5)
begin
	RAISERROR('Sorry, selected rating value(s) is (are) not in appropriate range!',16,1);
	return;
end;
else
begin
	insert into @ratings select distinct rating_id, rating_reservation_id, rating_guest_id, trim(rating_note), rating_total from Rating where rating_total <= @total_rating and rating_room <= @room_rating and rating_staff <= @staff_rating; 
	-- if manager wants to display ratings by both guest_id and reservation id
	if (@res_id is not null and @guest_id is not null)
	begin
		delete from @ratings where res_id != @res_id or guest_id != @guest_id;
	end;
	-- if manager wants to display ratings only by reservatio n id
	else if (@res_id is not null and @guest_id is null)
	begin
		delete from @ratings where res_id != @res_id;
	end;
	-- if manager wants to display ratings only by guest_id
	else if (@res_id is null and @guest_id is not null)
	begin
		delete from @ratings where guest_id != @guest_id;
	end;
	-- if manager wants to display all ratings
	else
	begin
		print('');
	end;
	set @row_num = (select sum(rating_id) from @ratings);
	-- create error if no such such guest, res
	if @row_num > 0
	begin
		while @row_num != 0
		begin
			set @n_rating_id = (select top(1) rating_id from @ratings order by rating_id asc);
			set @n_reserv_id = (select top(1) res_id from @ratings order by rating_id asc);
			set @n_guest_id = (select top(1) guest_id from @ratings order by rating_id asc);
			set @n_note = (select top(1) rating_note from @ratings order by rating_id asc);
			set @total_r = (select top(1) rating_total from @ratings order by rating_id asc);
			set @result = '#'+concat(convert(varchar(5), @n_rating_id), char(10), 'Guest id: ', convert(varchar(5), @n_guest_id), char(10), 'Reservation id: ', convert(varchar(5), @n_reserv_id), char(10));
			set @result = @result + dbo.whichRoomAndType(@n_reserv_id, @n_guest_id) + dbo.whichStaff(@n_reserv_id, @n_guest_id) + 'Total rating: ' + convert(varchar(5),@total_r) + char(10) + 'Note: ' + trim(@n_note) + char(10);
			set @row_num = @row_num - 1;
			print(trim(@result));
			delete from @ratings where rating_id = @n_rating_id;
		end;
	end
	else
	begin
		RAISERROR('Sorry, there is no rating information founded by given data!',16,1)
		return
	end;
end;
end;
drop procedure roomAndStaffRating
--exec roomAndStaffRating @total_rating = 4.7, @staff_rating = 10;
--exec roomAndStaffRating @guest_id = 102, @res_id = 1;
--exec roomAndStaffRating @res_id = 110;


--TRIGGER to calculte total rating
create trigger totalRating
on Rating after insert, update
as begin
declare @total real, @food_rating real, @staff_rating real, @room_rating real, @rating_date date, @rating_id int;
set @rating_id = (select rating_id from inserted);
set @food_rating = (select rating_food from inserted);
set @staff_rating = (select rating_staff from inserted);
set @room_rating = (select rating_room from inserted);
set @rating_date = (select rating_date from inserted);
if @food_rating is not null
begin
	set @total = (@room_rating + @staff_rating + @food_rating)/3;
	update Rating set rating_total = round(@total,2) where rating_id=@rating_id;
end;
else
begin
	set @total = (@room_rating + @staff_rating)/2;
	update Rating set rating_total = round(@total,2) where rating_id=@rating_id;
end;	
if @rating_date is null
begin
	set @rating_date = getdate();
	update Rating set rating_date=@rating_date where rating_id=@rating_id;
end;
end;
--drop trigger totalRating
--insert into Rating values (7, 105, 5, 4.5, 5, 4.6, null, null, 'Television doesn`t have many various channels');
--delete from rating where rating_id=7


-- 1, 2 procedures
alter table ROOM
add roomAvailability varchar(15);
alter Table RESERVATION
add prepayment int;
alter table RESERVATION
add reservation_status varchar(15);

/* 1) УЧЕСТЬ пожелания гостя 
   2) Перед регистрацией проверить наличие свободных номеров выбранной категории (эконом/люкс и тд, одноместный/двухместный и тд).
   3) Необходим триггер на обновление данных в таблице свободных номеров 
   3.1) В случае наличия свободного номера происходит регистрация клиента на check-in/check-out определенного дня */

CREATE FUNCTION checkForRoomForAvailability(@roomId int , @guestArrivalDate date,@guestDepartureDate date)
returns varchar(8)
BEGIN
	DECLARE @isBusy varchar(8)
	DECLARE @roomNumber int = 0;
	SET @roomNumber = (select COUNT(*) from RESERVATION where reservation_room_id = @roomId AND 
	reservation_status LIKE 'ACTIVE' and ((arrival_date BETWEEN @guestArrivalDate 
	AND @guestDepartureDate) or (departure_date BETWEEN @guestArrivalDate AND @guestDepartureDate)))
	IF @roomNumber>0
	BEGIN
		SET @isBusy = 'Busy'
	END
	ELSE
	BEGIN
		SET @isBusy = 'Not Busy'
	END
	return @isBusy
END

CREATE FUNCTION getRoomsByTypeAndFloor(@desiredRoomType varchar(15),@desiredFloor int,@arrivalDate date,@departureDate date)
returns TABLE
AS
RETURN
(
	select ROOM.room_id from ROOM 
	where ROOM.room_type = @desiredRoomType and 
	ROOM.room_floor = @desiredFloor and dbo.checkForRoomForAvailability(ROOM.room_id,@arrivalDate,@departureDate) Like 'Not Busy' 
);

CREATE FUNCTION getRoomsByType(@desiredRoomType varchar(15),@arrivalDate date,@departureDate date)
returns TABLE
AS
RETURN
(
	select ROOM.room_id from ROOM 
	where ROOM.room_type = @desiredRoomType and dbo.checkForRoomForAvailability(ROOM.room_id,@arrivalDate,@departureDate) Like 'Not Busy'
);

CREATE FUNCTION getRoomsByFloor(@desiredFloor int,@arrivalDate date,@departureDate date)
returns TABLE
AS
RETURN
(
	select ROOM.room_id from ROOM 
	where ROOM.room_floor = @desiredFloor and dbo.checkForRoomForAvailability(ROOM.room_id,@arrivalDate,@departureDate) Like 'Not Busy'
);

CREATE FUNCTION getRoomsAvailable(@arrivalDate date,@departureDate date)
returns TABLE
AS
RETURN
(
	select ROOM.room_id from ROOM 
	where dbo.checkForRoomForAvailability(ROOM.room_id,@arrivalDate,@departureDate) Like 'Not Busy'
);

CREATE FUNCTION getNumberOfRegistersByIdAndDate(@guestId int,@arrivalDate date,@departureDate date)
returns int
BEGIN
	DECLARE @numberOfRents int = 0
	SET @numberOfRents = (select count(*) from GUEST_RESERVATION g_r join RESERVATION res on res.reservation_id = g_r.reservation_id
	where guest_id = @guestId AND reservation_status LIKE 'ACTIVE' AND 
	((arrival_date BETWEEN @arrivalDate AND @departureDate) OR (departure_date BETWEEN @arrivalDate AND @departureDate)));
	return @numberOfRents
END

select * from Guest_Reservation
select * from RESERVATION
select * from guest
select * from Hotel_Invoice
--exec registerNewGuest @guestId = 121 , @guestName = 'Hinata', @guestSurname = 'Huga', @guestAddress = 'HZ', @guestDateOfBirth = '2001-01-31',@guestFamilyStatus ='Single', @guestPhoneNumber = '243-432-1241', @guestEmail = 'h_hugaaaaaa@kbtu.kz', @desiredRoomType ='double',  @desiredFloor = '2', @dayOfArrival= '2021-08-23', @dayOfDeparture = '2021-08-28', @prepayment = 50, @petNumber = 0, @childNumber = 0, @gender = 'Female'
--exec joinCurrentGuestRoom @guestFindId = 121, @guestId = 141,@guestName = 'Micky', @guestSurname = 'Rock', @guestAddress='Erzhanova 28',@guestDateOfBirth = '2001-07-18',@guestFamilyStatus = 'Married',@guestPhoneNumber= '123-648-1232',@guestEmail = 'rock_micky@kbtu.kz', @dayOfArrival = '2021-08-23', @petNumber =0,@childNumber = 0, @gender= 'Male'
--exec spCancelBooking @guestId = 141, @arrivalGuestDate ='2021-08-23' , @departureGuestDate = '2021-08-28'

CREATE PROCEDURE joinCurrentGuestRoom
@guestFindId int,
@guestId int,
@guestName varchar(20),
@guestSurname varchar(20),
@guestAddress varchar(20),
@guestDateOfBirth date,
@guestFamilyStatus varchar(20),
@guestPhoneNumber varchar(15),
@guestEmail varchar(25),
@dayOfArrival date,
@petNumber int,
@childNumber int,
@gender varchar(7)
AS
BEGIN
	IF(dbo.getExistedGuest(@guestFindId) is NULL)
	BEGIN
		RAISERROR('Sorry,but there is no such person in Hotel!',16,1)
		return
	END
	ELSE
	BEGIN
		IF(dbo.getExistedGuest(@guestId) is NULL)
		BEGIN
			IF(dbo.checkForDataGuest(@guestId,@guestName ,@guestSurname ,@guestAddress ,@guestDateOfBirth,@guestFamilyStatus ,@guestPhoneNumber) Like 'No')
			BEGIN
				RAISERROR('Sorry, You did not fill all the data completely!',16,1)
				return
			END
			ELSE
			BEGIN
				insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
			END
		END
		
		DECLARE @guestReservationId int = NULL 
		SET @guestReservationId = (select TOP(1) res.reservation_id from RESERVATION res join GUEST_RESERVATION g_r 
		on res.reservation_id = g_r.reservation_id where res.reservation_status LIKE 'ACTIVE' AND g_r.guest_id = @guestFindId AND res.arrival_date = @dayOfArrival)
		
		IF (@guestReservationId is NULL)
		BEGIN
			RAISERROR('Sorry, but there is no such RESERVATION in Hotel !',16,1)
			return
		END

		insert into GUEST_RESERVATION values(@guestReservationId,@guestId,@petNumber,@childNumber)
	END
END

CREATE FUNCTION getExistedGuest(@guestIdTaken int)
returns int
BEGIN
	DECLARE @foundGuest int = NULL
	SET @foundGuest  = (select guest_id from GUEST where guest_id = @guestIdTaken)
	return @foundGuest
END

CREATE FUNCTION checkForDataGuest(@guestId int,@guestName varchar(20),@guestSurname varchar(20),@guestAddress varchar(20),@guestDateOfBirth date,@guestFamilyStatus varchar(20),@guestPhoneNumber varchar(15))
returns varchar(5)
BEGIN
	DECLARE @output varchar(5)
	IF (@guestId is NULL or @guestName is NULL or @guestSurname is NULL or @guestAddress is NULL or @guestDateOfBirth is NULL or @guestFamilyStatus is NULL or @guestPhoneNumber is NULL)
	BEGIN
		SET @output = 'No'
	END
	ELSE
	BEGIN
		SET @output = 'Yes'
	END
	return @output
END


CREATE PROCEDURE registerNewGuest
@guestId int,
@guestName varchar(20),
@guestSurname varchar(20),
@guestAddress varchar(20),
@guestDateOfBirth date,
@guestFamilyStatus varchar(20),
@guestPhoneNumber varchar(15),
@guestEmail varchar(25),
@desiredRoomType varchar(15),
@desiredFloor int,
@dayOfArrival date,
@dayOfDeparture date,
@prepayment real,
@petNumber int,
@childNumber int,
@gender varchar(7)
AS
BEGIN
	DECLARE @foundGuestId int = dbo.getExistedGuest(@guestId)
	DECLARE @foundRoomId int = NULL
	iF(@foundGuestId is NULL)
	BEGIN
		if (dbo.checkForDataGuest(@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber) Like 'No')
		BEGIN
			RAISERROR('Sorry, You did not fill all the Information completely!',16,1)
			return
		END
		ELSE
		BEGIN
			insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
		END
	END
	
	iF (@dayOfArrival is NULL OR @dayOfDeparture is NULL)
	BEGIN
		RAISERROR('Sorry, You did not fill the date of Accomodation!',16,1)
		return
	END

	IF (@desiredRoomType is NULL and @desiredFloor is NULL)
	BEGIN
		SET @foundRoomId = (select TOP(1) room_id from getRoomsAvailable(@dayOfArrival,@dayOfDeparture))
	END
	IF (@desiredRoomType is NULL and @desiredFloor is NOT NULL)
	BEGIN
		SET @foundRoomId = (select TOP(1) room_id from getRoomsByFloor(@desiredFloor,@dayOfArrival,@dayOfDeparture))
	END
	iF (@desiredRoomType is NOT NULL and @desiredFloor is NULL)
	BEGIN
		SET @foundRoomId = (select TOP(1) room_id from getRoomsByType(@desiredRoomType,@dayOfArrival,@dayOfDeparture))
	END
	IF (@desiredRoomType is NOT NULL and @desiredFloor is NOT NULL)
	BEGIN
		SET @foundRoomId = (select TOP(1) room_id from getRoomsByTypeAndFloor(@desiredRoomType,@desiredFloor,@dayOfArrival,@dayOfDeparture))
	END

	IF (@foundRoomId is NULL)
	BEGIN
		RAISERROR('Sorry, There is no available rooms By your Wish!',16,1)
		return
	END
	
	IF(@prepayment is NULL)
	BEGIN
		SET @prepayment = 0
	END
	
	IF dbo.getNumberOfRegistersByIdAndDate(@foundRoomId,@dayOfArrival,@dayOfDeparture) >0
	BEGIN
		RAISERROR('Sorry! However, you can not take more than One room for this period of time!',16,1)
		return
	END

	DECLARE @newResId int 
	SET @newResId = (select TOP(1) reservation_id + 1 from RESERVATION order by reservation_id DESC )
	insert into RESERVATION values (@newResId,@dayOfArrival,@dayOfDeparture,@foundRoomId,GetDate(),@prepayment,'ACTIVE')
	insert into GUEST_RESERVATION values (@newResId,@guestId,@petNumber,@childNumber)
END


CREATE TRIGGER tr_RoomUpdate
on RESERVATION
FOR insert
AS
BEGIN
	DECLARE @roomIdNeeded int 
	DECLARE @roomType varchar(15)
	DECLARE @roomFloor int
	DECLARE @startDate date
	DECLARE @endDate date

	select @roomIdNeeded = reservation_room_id from inserted 
	SET @roomType = (select room_type from ROOM where room_id = @roomIdNeeded)
	SET @roomFloor = (select room_floor from ROOM where room_id = @roomIdNeeded)
	select @startDate = arrival_date from inserted
	select @endDate = departure_date from inserted
	
	DECLARE @roomDescription varchar(200) = 'The room with ID = ' + CAST(@roomIdNeeded as varchar) + ' is BUSY FROM ' + CAST(@startDate as varchar) + ' to ' + CAST(@endDate as varchar) 
	
	insert into room_audit(room_id,room_status,room_date_beginning,room_date_end,room_description) values(@roomIdNeeded,'BUSY',@startDate,@endDate,@roomDescription)

	PRINT CONCAT('The room with type ',@roomType, ', ID = ',CAST(@roomIdNeeded as varchar), ' on the ',CAST(@roomFloor as varchar),' floor ','is BUSY from ',CAST(@startDate as varchar),' to ',CAST(@endDate as varchar))
END


CREATE FUNCTION getPrepayment(@reservationID int)
returns int
BEGIN
	DECLARE @foundPrepayment int = NULL
	SET @foundPrepayment = (select prepayment from RESERVATION where reservation_id = @reservationID)
	return @foundPrepayment
END

CREATE PROCEDURE spCancelBooking 
@guestId int,
@arrivalGuestDate date,   
@departureGuestDate date		
AS
BEGIN
	DECLARE @reservationId int = NULL
	SET @reservationId = (select res.reservation_id from GUEST_RESERVATION g_r join RESERVATION res on res.reservation_id = g_r.reservation_id 
	where guest_id = @guestId and reservation_status LIKE 'ACTIVE' and arrival_date = @arrivalGuestDate and departure_date = @departureGuestDate)
	
	IF(@reservationId is NULL)
	BEGIN
		RAISERROR('Sorry, There is no such Reservation with this ID ',16,1)
		return
	END

	DECLARE @dateDifference real = (DATEDIFF(minute,GetDate(),@arrivalGuestDate))
	IF (@dateDifference/60.0 >=24.0)
	BEGIN
		DECLARE @foundPrepayment int
		SET @foundPrepayment = dbo.getPrepayment(@reservationId)
		
		IF (@foundPrepayment > 0)
		BEGIN
			UPDATE HOTEL_INVOICE
			SET hotel_invoice_total_cost =-1*@foundPrepayment
			WHERE hotel_invoice_reservation_id = @reservationId

		END

		DELETE FROM GUEST_RESERVATION
		WHERE reservation_id = @reservationId

		UPDATE RESERVATION 
		SET reservation_status = 'CANCELED'
		WHERE reservation_id = @reservationId
	END
	ELSE
	BEGIN
		RAISERROR('Sorry, The remainded time is less than 24 to cancel Booking. You can not cancel Booking!',16,1)
		return
	END
END

CREATE TRIGGER trForCancelBooking
on GUEST_RESERVATION
AFTER DELETE
AS
BEGIN
	DECLARE @deletedReservationId int
	SET @deletedReservationId = (select TOP(1) reservation_id from deleted)
	DECLARE @cancelledRoomId int
	SET @cancelledRoomId = (select reservation_room_id from RESERVATION where reservation_id = @deletedReservationId)
	DECLARE @initialDate date
	SET @initialDate = (select arrival_date from RESERVATION where reservation_id = @deletedReservationId)
	DECLARE @endDate date
	SET @endDate = (select departure_date from RESERVATION where reservation_id = @deletedReservationId)
	DECLARE @foundPrepayment int
	SET @foundPrepayment = (select prepayment from RESERVATION where reservation_id = @deletedReservationId)

	
	UPDATE room_audit
	SET room_status = 'AVAILABLE',
	room_description = 'The room with id = ' + CAST(@cancelledRoomId as varchar) + ' was BUSY from ' + CAST(@initialDate as varchar)+ ' to ' + CAST(@endDate as varchar) + ' but now is available in this period'
	WHERE room_id = @cancelledRoomId AND room_date_beginning = @initialDate AND room_date_end = @endDate
	
	PRINT('The reservation with ID = ' + CAST(@deletedReservationId as varchar) +
	' has been CANCELED and the Room with ID = ' + CAST(@cancelledRoomId as varchar) + ' on the period from ' + CAST(@initialDate as varchar) + ' to ' + CAST(@endDate as varchar) + ' became free.' 
	+ 'The sum with the amount of ' + CAST(@foundPrepayment as varchar) + ' has been successfully returned.' )
END

exec registerNewGuest @guestId = 111, @guestName = 'Naruto', @guestSurname = 'Uzumaki',@guestAddress = 'HZ', @guestDateOfBirth = '2001-01-31', @guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1212', @guestEmail = 'n_uzumaki@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-12-01', @dayOfDeparture = '2021-12-10', @prepayment = 50, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 111, @guestName = 'Naruto', @guestSurname = 'Uzumaki',@guestAddress = 'HZ', @guestDateOfBirth = '2001-01-31', @guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1212', @guestEmail = 'n_uzumaki@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-12-01', @dayOfDeparture = '2021-12-10', @prepayment = 50, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 111, @guestName = 'Naruto', @guestSurname = 'Uzumaki',@guestAddress = 'HZ', @guestDateOfBirth = '2001-01-31', @guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1212', @guestEmail = 'n_uzumaki@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-09-01', @dayOfDeparture = '2021-09-10', @prepayment = 50, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 111, @guestName = 'Naruto', @guestSurname = 'Uzumaki',@guestAddress = 'HZ', @guestDateOfBirth = '2001-01-31', @guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1212', @guestEmail = 'n_uzumaki@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-09-12', @dayOfDeparture = '2021-09-20', @prepayment = 100, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 131, @guestName = 'Jake', @guestSurname = 'Uzumaki', @guestAddress = 'Green 131', @guestDateOfBirth = '2001-01-31', @guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1200', @guestEmail = 'j_uzumaki@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-10-05', @dayOfDeparture = '2021-10-12', @prepayment = 100, @petNumber = 0, @childNumber = 0, @gender = 'Male'

CREATE TABLE room_audit(
	number_audit integer identity(1,1) constraint pk_room_audit PRIMARY KEY,
	room_id integer not NULL,
	room_status varchar(20) not NULL,
	room_date_beginning date not NULL,
	room_date_end date not NULL,
	room_description varchar(200),
	constraint fk_room_audit_room_id FOREIGN KEY(room_id) REFERENCES ROOM(room_id)
);

-- 3, 4 procedures 
alter table guest drop column payment_type;

alter table guest add gender varchar(6);
update guest set gender = 'male' where guest_id = 101;
update guest set gender = 'female' where guest_id = 102;
update guest set gender = 'female' where guest_id = 103;
update guest set gender = 'male' where guest_id = 104;
update guest set gender = 'female' where guest_id = 105;
update guest set gender = 'male' where guest_id = 106;
update guest set gender = 'male' where guest_id = 107;
update guest set gender = 'male' where guest_id = 108;
update guest set gender = 'female' where guest_id = 109;
update guest set gender = 'male' where guest_id = 110;

/* create payment type in invoice tables */
alter table hotel_invoice add payment_type varchar(4);
alter table firm_invoice add payment_type varchar(4);

update hotel_invoice set payment_type = 'cash' where hotel_invoice_id = 1;
update hotel_invoice set payment_type = 'cash' where hotel_invoice_id = 2;
update hotel_invoice set payment_type = 'card' where hotel_invoice_id = 3;
update hotel_invoice set payment_type = 'card' where hotel_invoice_id = 4;
update hotel_invoice set payment_type = 'cash' where hotel_invoice_id = 5;
update hotel_invoice set payment_type = 'card' where hotel_invoice_id = 6;
update hotel_invoice set payment_type = 'card' where hotel_invoice_id = 7;

update firm_invoice set payment_type = 'cash' where firm_invoice_id = 1;
update firm_invoice set payment_type = 'card' where firm_invoice_id = 2;
update firm_invoice set payment_type = 'cash' where firm_invoice_id = 3;
update firm_invoice set payment_type = 'card' where firm_invoice_id = 4;
update firm_invoice set payment_type = 'cash' where firm_invoice_id = 5;
update firm_invoice set payment_type = 'card' where firm_invoice_id = 6;
update firm_invoice set payment_type = 'cash' where firm_invoice_id = 7;

alter table reservation add prepayment int;
update reservation set prepayment = 0 where reservation_id = 1;
update reservation set prepayment = 0 where reservation_id = 2;
update reservation set prepayment = 500 where reservation_id = 3;
update reservation set prepayment = 0 where reservation_id = 4;
update reservation set prepayment = 0 where reservation_id = 5;
update reservation set prepayment = 200 where reservation_id = 6;
update reservation set prepayment = 0 where reservation_id = 7;
update reservation set prepayment = 400 where reservation_id = 8;

/* 3 */
/* function shows the period of stay at the hotel for the guest */
create function FuncShowPeriodOfLiving(
	@reservation_id int
)
returns int
as
begin
	return(select datediff(day, arrival_date, departure_date) as duration from reservation where reservation_id = @reservation_id);
end;

/* Procedure that changes room day cost */
create procedure ChangeRoomTypeDayCost @room_type varchar(15), @cost int
as
begin
	if (@room_type in (select room_type from room_type))
		update room_type set room_day_cost = @cost where room_type = @room_type;
	else
		raiserror('There is no such room type in the room_type table',16,1);
end;

exec ChangeRoomTypeDayCost @room_type = 'family', @cost = 400

select * from guest_reservation;
select * from ROOM_TYPE

/* 4 */
/* function prints all hotel bills(for accommodation) */
create function FuncShowTotalCost()
returns table
as
return
	select * from hotel_invoice where hotel_invoice_staff_id = 1;

/* function that shows all guests that have stayed at the Hotel more than three times in one year */
create function FuncShowGuestWithDiscount(
@year varchar(4))
returns table
as
return
	select guest_id from
	(select guest_id, Count(guest_id) as NumOfVisits from guest_reservation gr
	join reservation r on gr.reservation_id = r.reservation_id
	where (reservation_date like @year+'%') and (reservation_status not like 'CANCELED') group by guest_id) t
	where NumOfVisits > 3;
drop function FuncShowGuestWithDiscount

/* Procedure that updates the hotel bill(-10% discount) if the guest has been to the hotel 3 times in a year */
create procedure Hotel_Invoice_ChangeTotalBill @year varchar(4), @staff_id int, @hotel_invoice_id int
as
begin
	if (@staff_id = 1)
		update hotel_invoice set hotel_invoice_total_cost = hotel_invoice_total_cost * 0.9
		where hotel_invoice_guest_id in (select * from FuncShowGuestWithDiscount(@year)) and hotel_invoice_id = @hotel_invoice_id;
end;
select * from Guest_Reservation

create trigger Guest_Reservation_CalculateHotelBill
on Guest_Reservation
after insert
as
begin
	declare @reservation_id int;
	declare @cost int;
	declare @year varchar(4);
	declare @hotel_invoice_id int;
	declare @date date;
	declare @guest_id int;
	declare @prepayment int;
	declare @hotel_invoice_total_cost int;
	declare @num_of_guests int;

	set @reservation_id = (select reservation_id from inserted);
	set @num_of_guests = (select Count(reservation_id) from guest_reservation where reservation_id = @reservation_id);

	if (@num_of_guests < 2)
	begin
		set @guest_id = (select guest_id from inserted);
		set @date = (select reservation_date from reservation where reservation_id = @reservation_id);
		set @hotel_invoice_id = (select TOP 1 hotel_invoice_id from hotel_invoice order by hotel_invoice_id desc)+1;
		set @year = substring(convert(varchar,@date), 1, 4);
		set @cost = (select r_t.room_day_cost from guest_reservation g_r
		join reservation r on g_r.reservation_id = r.reservation_id
		join room on r.reservation_room_id = room.room_id
		join room_type r_t on room.room_type = r_t.room_type
		where g_r.reservation_id = @reservation_id);
		set @prepayment = (select prepayment from reservation where reservation_id = @reservation_id);
		set @hotel_invoice_total_cost = (@cost * dbo.FuncShowPeriodOfLiving(@reservation_id));

		insert into hotel_invoice values(@hotel_invoice_id, @reservation_id, @guest_id, 1, @hotel_invoice_total_cost, @date, null);
		exec Hotel_Invoice_ChangeTotalBill @year = @year, @staff_id = 1, @hotel_invoice_id = @hotel_invoice_id;
		update Hotel_Invoice set hotel_invoice_total_cost = hotel_invoice_total_cost - @prepayment where hotel_invoice_id = @hotel_invoice_id;
	end;
	else
		print('There is already hotel bill invoice for this reservation');
end;

select * from hotel_invoice
/* drop trigger Guest_Reservation_CalculateHotelBill; */

/* Test */
/*
select * from room_type;
select * from hotel_invoice;
select * from reservation;
select * from guest_reservation;
select * from room;
select * from hotel_staff;

insert into reservation values(9,'2021-06-04','2021-06-28',456,'2021-06-03',0);
insert into reservation values(10,'2021-11-12','2021-11-20',202,'2021-11-11',0);
insert into reservation values(11,'2021-12-21','2021-12-31',205,'2021-12-15',0);

insert into reservation values(12,'2021-06-04','2021-06-28',456,'2021-06-03',0);
insert into reservation values(13,'2021-11-12','2021-11-20',202,'2021-11-11',0);
insert into reservation values(14,'2021-12-21','2021-12-31',500,'2021-12-15',0);

insert into Guest_Reservation values(9, 101, 0, 0);
insert into Guest_Reservation values(10, 101, 0, 0);
insert into Guest_Reservation values(11, 101, 0, 0);

insert into Guest_Reservation values(12, 104, 0, 0);
insert into Guest_Reservation values(13, 104, 0, 0);
insert into Guest_Reservation values(14, 104, 0, 0);

insert into hotel_invoice values(8, 3, 104, 1, 2000, '2021-05-16', 'card'); -- 11 days, family(400-changed), prepayment = 500
insert into hotel_invoice values(9, 8, 109, 1, 2000, '2021-05-20', 'card'); -- 9 days, double(200), prepayment = 400
insert into hotel_invoice values(10, 14, 104, 1, 2000, '2021-12-30', 'card'); -- 9 days, president(5000)
insert into hotel_invoice values(12, 11, 101, 1, 2000, '2021-12-31', 'card'); -- 10 days, double(200) 

exec ChangeRoomTypeDayCost @room_type = 'family', @cost = 300;
select * from FuncShowGuestWithDiscount('2021');

update hotel_invoice set payment_type = 'card' where hotel_invoice_id = 10;
delete from hotel_invoice where hotel_invoice_id = 8;
delete from Guest_Reservation where reservation_id = 9;
delete from reservation where reservation_id = 9; */
