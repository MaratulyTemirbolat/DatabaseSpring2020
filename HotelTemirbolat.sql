create database hotel;
use hotel;
UPDATE GUEST_RESERVATION
SET child_number = 0
where child_number is NULL

select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,
res.reservation_date,res.prepayment,res.reservation_status,g_r.guest_id,
g_r.pet_number,g_r.child_number from RESERVATION res join GUEST_RESERVATION g_r 
on res.reservation_id = g_r.reservation_id;

select count(*) from RESERVATION res join GUEST_RESERVATION g_r on res.reservation_id = g_r.reservation_id;

select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,
    										res.reservation_date,res.prepayment,res.reservation_status,g_r.guest_id 
											from RESERVATION res join GUEST_RESERVATION g_r 
											on res.reservation_id = g_r.reservation_id;

--Extra
ALTER TABLE room_audit
ADD reservation_id int constraint fk_reservation FOREIGN KEY(reservation_id) REFERENCES RESERVATION(reservation_id);

ALTER TABLE room_audit
ADD guest_id int constraint fk_guest_id FOREIGN KEY(guest_id) REFERENCES GUEST(guest_id);
select * from room_audit;
CREATE FUNCTION getAmountAccomodationThisYear(@guestId int)
returns int
BEGIN
	DECLARE @amountOfVisits int;
	DECLARE @currentYear int;
	SET @currentYear = (select YEAR(GetDate()))
	SET @amountOfVisits = ( select count(*) from room_audit 
	where guest_id = @guestId and room_description LIKE '%leave%' and 
	(YEAR(room_date_beginning) = @currentYear or YEAR(room_date_end) = @currentYear))
	return @amountOfVisits
END

CREATE PROCEDURE fillRoomAuditLeave 
@option int,
@reservation_id int,
@guest_id int,
@room_id int,
@room_date_beginning date,
@room_date_end date
AS
BEGIN
	DECLARE @number_audit int;
	SET @number_audit = (select count(*) + 1 from room_audit)
	DECLARE @description varchar(200)
	IF(@option = 0 or @option = 1)
	BEGIN
		IF(@option = 0)
		BEGIN
			SET @description = 'The OWNER decided to leave the room at ' + CAST(GetDate() as varchar)
			INSERT INTO room_audit VALUES(@number_audit,@room_id,'AVAILABLE',@room_date_beginning,@room_date_end,@description,@reservation_id,@guest_id)
		END
		ELSE
		BEGIN
			SET @description = 'The JOINED person decided to leave the room at ' + CAST(GetDate() as varchar)
			INSERT INTO room_audit VALUES(@number_audit,@room_id,'BUSY',@room_date_beginning,@room_date_end,@description,@reservation_id,@guest_id) 
		END
	END
	ELSE
	BEGIN
		SET @description = 'The guest decided to leave the room at ' + CAST(GetDate() as varchar)
		INSERT INTO room_audit VALUES(@number_audit,@room_id,'BUSY',@room_date_beginning,@room_date_end,@description,@reservation_id,@guest_id)
	END
END


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
alter table ROOM
add roomAvailability varchar(15);

create table singleGlobalVariable(
	singleVariable integer
);
insert into singleGlobalVariable values (1)
select * from singleGlobalVariable
UPDATE singleGlobalVariable 
SET singleVariable = 1;

CREATE VIEW firm_personal AS 
select * from FIRM_STAFF f_s join FIRM f on f_s.firm_id = f.firm_id

CREATE VIEW general_staff AS
select firm_staff_id as staff_id,firm_staff_name as staff_name,firm_staff_surname as staff_surname,
firm_department_id as department_id,firm_staff_salary as staff_salary from firm_personal
UNION
select hotel_staff_id as staff_id, hotel_staff_name as staff_name,hotel_staff_surname as staff_surname,
hotel_staff_department_id as department_id,hotel_staff_salary as staff_salary from HOTEL_STAFF

select * from FIRMS_STAFF where firm_staff_id = 12 
select * from HOTEL STAFF where hotel_staff_id = 12
select * from general_staff where firm_staff_id = 12

CREATE FUNCTION findIdOftheEmployeeAmongHotelStaff(@foundEmployeeID int)
returns int
BEGIN
	DECLARE @foundId int = NULL
	SET @foundId = (select hotel_staff_id from HOTEL_STAFF where hotel_staff_id = @foundEmployeeID)
	return @foundId
END

CREATE FUNCTION findIdOftheEmployeeAmongFirmStaff(@foundEmployeeID int)
returns int
BEGIN
	DECLARE @foundId int = NULL
	SET @foundId = (select firm_staff_id from FIRM_STAFF where firm_staff_id = @foundEmployeeID)
	return @foundId
END

exec spDismissEmployee @employeeId = 43, @departmentId = 42, @reason = '';

CREATE PROCEDURE spDismissEmployee
@employeeId int,
@departmentId int,
@reason varchar(150)
AS
BEGIN
	IF(@employeeId is NULL or @reason is NULL)
	BEGIN
		IF(@employeeId is NULL)
		BEGIN
			RAISERROR('Sorry, but you DID not type the id of the Employee!',16,1)
			return
		END
		IF(@reason is NULL and @employeeId is not NULL)
		BEGIN
			RAISERROR('Sorry, but you can not dismiss employee without corresponded reason!',16,1)
			return
		END
	END
	
	DECLARE @foundFirmEmployeeId int = NULL
	DECLARE @foundHotelEmployeeId int = NULL
	SET @foundFirmEmployeeId = dbo.findIdOftheEmployeeAmongFirmStaff(@employeeId)
	SET @foundHotelEmployeeId = dbo.findIdOftheEmployeeAmongHotelStaff(@employeeId)
	
	IF(@foundFirmEmployeeId is NULL and @foundHotelEmployeeId is NULL)
	BEGIN
		RAISERROR('Sorry,but there is no any person with this ID there!',16,1)
		return
	END
	
	/*IF(@foundFirmEmployeeId = @foundHotelEmployeeId and (@foundFirmEmployeeId is not NULL and @foundHotelEmployeeId is not NULL))
	BEGIN
		--ÈÑÏÐÀÂÈÒÜ
		RAISERROR('Sorry,but there is no possibility to have the same workers!',16,1)
		return
	END*/

	DELETE FROM general_staff 
	where staff_id = @employeeId

	UPDATE FORMER_STAFF
	SET		 = @reason
	WHERE hotel_staff_id = @employeeId and reasonOfDismissing is NULL
	
END

CREATE TRIGGER trGeneralStaffInsteadOfDelete
on general_staff
instead of DELETE
AS
BEGIN
	DECLARE @deletedId int
	SET @deletedId = (select TOP(1) staff_id from deleted)
	DECLARE @foundName varchar(20)
	SET @foundName = (select TOP(1) staff_name from deleted)
	DECLARE @foundSurname varchar(20)
	SET @foundSurname = (select TOP(1) staff_surname from deleted)

	DECLARE @staffDepIdHotel int,@staffDepIdFirm int
	DECLARE @jobTittleHotel varchar(20),@jobTittleFirm varchar(20)
	DECLARE @salaryHotel int,@salaryFirm int
	DECLARE @email varchar(20)
	DECLARE @phoneNumber varchar(20) -- Êîñÿê â ERD
	DECLARE @address varchar(50)
	DECLARE @joiningDateHotel date,@joiningDateFirm date
	DECLARE @workFloorHotel int,@workFloorFirm int
	DECLARE @birthDay date
	DECLARE @gender varchar(6)
	DECLARE @previousJobTitleHotel varchar(40),@previousJobTitleFirm varchar(40) --ÏÎÄ ÂÎÏÐÎÑÎÌ ÍÓÆÄÛ
	DECLARE @previousWorkPlaceHotel varchar(40),@previousWorkPlaceFirm varchar(40) -- ÏÎÄ ÂÎÏÐÎÑÎÌ ÍÓÆÄÛ
	DECLARE @jobExperienceHotel int,@jobExperienceFirm int  -- ÏÎÄ ÂÎÏÐÎÑÎÌ
	DECLARE @highestEducationLevelHotel varchar(40),@highestEducationLevelFirm varchar(40)
	DECLARE @specialityHotel varchar(70),@specialityFirm varchar(70) -- ÏÎÄ ÂÎÏÐÎÑÎÌ
	DECLARE @startTimeHotel time,@startTimeFirm time
	DECLARE @endTimeHotel time,@endTimeFirm time
	
	DECLARE @isFirm int = 0
	SET @isFirm = (select count(*) from FIRM_STAFF where firm_staff_id = @deletedId)
	IF(@isFirm > 0)
	BEGIN
		SET @staffDepIdFirm = (select TOP(1) firm_id from FIRM_STAFF where firm_staff_id = @deletedId )
		SET @jobTittleFirm = (select TOP(1) firm_staff_job_title from FIRM_STAFF where firm_staff_id = @deletedId )
		SET @salaryFirm = (select TOP(1) firm_staff_salary_per_hour from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @joiningDateFirm = (select TOP(1) firm_joining_date from FIRM_STAFF where firm_staff_id = @deletedId )
		SET @workFloorFirm = (select TOP(1) f.firm_floor from FIRM_STAFF f_s join FIRM f on f_s.firm_id = f.firm_id where firm_staff_id = @deletedId)
		SET @startTimeFirm = (select TOP(1) firm_staff_start_time from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @endTimeFirm = (select TOP(1) firm_staff_end_time from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @email = (select TOP(1) firm_staff_email from FIRM_STAFF where firm_staff_id = @deletedId )
		SET @phoneNumber = (select TOP(1) firm_staff_phone_number from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @address = (select TOP(1) firm_staff_address from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @birthDay = (select TOP(1) firm_staff_birthday from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @gender = (select TOP(1) firm_staff_gender from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @previousJobTitleFirm = (select TOP(1) previous_job_title from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @previousWorkPlaceFirm = (select TOP(1) previous_workplace from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @jobExperienceFirm = (select TOP(1) job_experience from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @highestEducationLevelFirm = (select TOP(1) highest_education_level from FIRM_STAFF where firm_staff_id = @deletedId)
		SET @specialityFirm = (select TOP(1) speciality from FIRM_STAFF where firm_staff_id = @deletedId)
	END

	DECLARE @isHotel int = 0
	SET @isHotel = (select count(*) from HOTEL_STAFF where hotel_staff_id = @deletedId)
	IF(@isHotel > 0)
	BEGIN
		SET @staffDepIdHotel = (select TOP(1) hotel_staff_department_id from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @jobTittleHotel = (select TOP(1) previous_job_title from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @salaryHotel = (select TOP(1) hotel_staff_salary_per_hour from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @joiningDateHotel = (select TOP(1) hotel_staff_joining_date from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @workFloorHotel = (select TOP(1) hotel_staff_work_floor from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @startTimeHotel = (select TOP(1) start_time from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @endTimeHotel = (select TOP(1) end_time from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @email = (select TOP(1) hotel_staff_email from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @phoneNumber = (select TOP(1) hotel_staff_phone_number from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @address = (select TOP(1) hotel_staff_address from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @birthDay = (select TOP(1) birthday from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @gender = (select TOP(1) gender from  HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @previousJobTitleHotel = (select TOP(1) previous_job_title from HOTEL_STAFF where hotel_staff_id = @deletedId) 
		SET @previousWorkPlaceHotel = (select TOP(1) previous_workplace from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @jobExperienceHotel = (select TOP(1) job_experience from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @highestEducationLevelHotel = (select TOP(1) highest_education_level from HOTEL_STAFF where hotel_staff_id = @deletedId)
		SET @specialityHotel = (select TOP(1) speciality from HOTEL_STAFF where hotel_staff_id = @deletedId)
	END

	DECLARE @timeDifferenceFirm int = 0;
	DECLARE @timeDifferenceHotel int = 0;
	DECLARE @passedDays int = DATEPART(day,GetDate())
	DECLARE @finalMoneyFirm int,@finalMoneyHotel int
	IF(@isFirm > 0 and @isHotel > 0)
	BEGIN
		SET @timeDifferenceFirm = ABS(DATEDIFF(hour,@startTimeFirm,@endTimeFirm))
		SET @timeDifferenceHotel = ABS(DATEDIFF(hour,@startTimeHotel,@endTimeHotel))
		SET @finalMoneyFirm = @salaryFirm*@timeDifferenceFirm*@passedDays
		SET @finalMoneyHotel = @salaryHotel*@timeDifferenceHotel*@passedDays

		insert into FORMER_STAFF values(@deletedId,@foundName,@foundSurname,@staffDepIdFirm,@jobTittleFirm,@salaryFirm,@email,@phoneNumber,@address,@joiningDateFirm,@workFloorFirm,@birthDay,@gender,@previousJobTitleFirm,@previousWorkPlaceFirm,@jobExperienceFirm,@highestEducationLevelFirm,@specialityFirm,@startTimeFirm,@endTimeFirm,@finalMoneyFirm,NULL)
		insert into FORMER_STAFF values(@deletedId,@foundName,@foundSurname,@staffDepIdHotel,@jobTittleHotel,@salaryHotel,@email,@phoneNumber,@address,@joiningDateHotel,@workFloorHotel,@birthDay,@gender,@previousJobTitleHotel,@previousWorkPlaceHotel,@jobExperienceHotel,@highestEducationLevelHotel,@specialityHotel,@startTimeHotel,@endTimeHotel,@finalMoneyHotel,NULL)

		DELETE FROM FIRM_STAFF
		WHERE firm_staff_id = @deletedId

		DELETE FROM HOTEL_STAFF
		WHERE hotel_staff_id = @deletedId
	END
	ELSE
	BEGIN
		IF(@isFirm > 0)
		BEGIN
			SET @timeDifferenceFirm = ABS(DATEDIFF(hour,@startTimeFirm,@endTimeFirm))
			SET @finalMoneyFirm = @salaryFirm*@timeDifferenceFirm*@passedDays
			insert into FORMER_STAFF values(@deletedId,@foundName,@foundSurname,@staffDepIdFirm,@jobTittleFirm,@salaryFirm,@email,@phoneNumber,@address,@joiningDateFirm,@workFloorFirm,@birthDay,@gender,@previousJobTitleFirm,@previousWorkPlaceFirm,@jobExperienceFirm,@highestEducationLevelFirm,@specialityFirm,@startTimeFirm,@endTimeFirm,@finalMoneyFirm,NULL)
			DELETE FROM FIRM_STAFF
			WHERE firm_staff_id = @deletedId
		END
		IF(@isHotel > 0)
		BEGIN
			SET @timeDifferenceHotel = ABS(DATEDIFF(hour,@startTimeHotel,@endTimeHotel))
			SET @finalMoneyHotel = @salaryHotel*@timeDifferenceHotel*@passedDays
			insert into FORMER_STAFF values(@deletedId,@foundName,@foundSurname,@staffDepIdHotel,@jobTittleHotel,@salaryHotel,@email,@phoneNumber,@address,@joiningDateHotel,@workFloorHotel,@birthDay,@gender,@previousJobTitleHotel,@previousWorkPlaceHotel,@jobExperienceHotel,@highestEducationLevelHotel,@specialityHotel,@startTimeHotel,@endTimeHotel,@finalMoneyHotel,NULL)
			DELETE FROM HOTEL_STAFF
			WHERE hotel_staff_id = @deletedId
		END
	END
	select 'The Employee '+ @foundName + ' ' + @foundSurname + ' with ID = ' + CAST(@deletedId as varchar) + ' is successfully Dismissed' 
END

CREATE FUNCTION findCurrentActiveReservationOfGuest(@guestId int)
returns int
BEGIN
	DECLARE @resultedReservation int = NULL
	SET @resultedReservation =  (select TOP(1) res.reservation_id from RESERVATION res join GUEST_RESERVATION g_r 
	on res.reservation_id = g_r.reservation_id where res.reservation_status LIKE 'ACTIVE' 
	and g_r.guest_id = @guestId and res.arrival_date<=GetDate() and GetDate()<=res.departure_date)
	return @resultedReservation
END

CREATE FUNCTION getOwnerOftheGuestReservation(@reservationId int)
returns int
BEGIN
	DECLARE @ownerId int = NULL
	SET @ownerId = (select TOP(1) hotel_invoice_guest_id from HOTEL_INVOICE h_i join HOTEL_STAFF h_s 
	on h_i.hotel_invoice_staff_id = h_s.hotel_staff_id
	where  h_i.hotel_invoice_reservation_id = @reservationId and h_s.hotel_staff_job_title LIKE 'Receptionist')
	return @ownerId;
END
select * from HOTEL_INVOICE
select * from GUEST_RESERVATION
select * from RESERVATION
exec spEvictGuest @guestId = 405
DROP PROCEDURE spEvictGuest
CREATE PROCEDURE spEvictGuest
@guestId int
AS
BEGIN
	IF(@guestId is NULL)
	BEGIN
		select 'Sorry,but YOU CAN NOT SEND NULL IDENTIFICATION NUMBER!'
		return
	END
	DECLARE @curActiveReservationId int = NULL
	SET @curActiveReservationId = dbo.findCurrentActiveReservationOfGuest(@guestId)
	IF(@curActiveReservationId is NULL)
	BEGIN
		select 'Sorry,but there is no CURRENT Active RESERVATIONS!'
		return
	END
	UPDATE singleGlobalVariable
	SET singleVariable = 2;
	DECLARE @ownerID int = dbo.getOwnerOftheGuestReservation(@curActiveReservationId)
	IF(@guestId = @ownerID)
	BEGIN
		DECLARE @numberHere int 
		SET @numberHere = (select count(*) from GUEST_RESERVATION where reservation_id = @curActiveReservationId)
		IF(@numberHere>1)
		BEGIN
			select 'All the Guests are successfully Left!'
		END
		ELSE
		BEGIN
			select 'The owner is successfully Left!'
		END
		DELETE FROM GUEST_RESERVATION
		WHERE reservation_id = @curActiveReservationId

		UPDATE RESERVATION 
		SET reservation_status = 'NOT ACTIVE'
		WHERE reservation_id = @curActiveReservationId
		-- Ñ×ÅÒ ÂÛÑÒÀÂËßÅÌ????? ÈËÈ Â ÒÐÈÃÃÅÐÅ?
	END
	ELSE
	BEGIN
		select 'The Guest is successfully left'
		DELETE FROM GUEST_RESERVATION
		WHERE reservation_id = @curActiveReservationId and guest_id = @guestId
		-- Ñ×ÅÒ ÂÛÑÒÀÂËßÅÌ????? ÈËÈ Â ÒÐÈÃÃÅÐÅ?
	END
END

/* 1) Ó×ÅÑÒÜ ïîæåëàíèÿ ãîñòÿ 
   2) Ïåðåä ðåãèñòðàöèåé ïðîâåðèòü íàëè÷èå ñâîáîäíûõ íîìåðîâ âûáðàííîé êàòåãîðèè (ýêîíîì/ëþêñ è òä, îäíîìåñòíûé/äâóõìåñòíûé è òä).
   3) Íåîáõîäèì òðèããåð íà îáíîâëåíèå äàííûõ â òàáëèöå ñâîáîäíûõ íîìåðîâ 
   3.1) Â ñëó÷àå íàëè÷èÿ ñâîáîäíîãî íîìåðà ïðîèñõîäèò ðåãèñòðàöèÿ êëèåíòà íà check-in/check-out îïðåäåëåííîãî äíÿ */
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
select * from RESERVATION res join GUEST_RESERVATION g_r on g_r.reservation_id = res.reservation_id;
select dbo.getNumberOfRegistersByIdAndDate(900,'2021-10-13','2021-10-15')
--? USED OR NOT
CREATE FUNCTION checkForTakingSeveralRoomsSameTime(@guestId int,@arrivalDate date)
returns varchar(5)
BEGIN
	DECLARE @output varchar(5)
	IF (dbo.getNumberOfRegistersByIdAndDate(@guestId,@arrivalDate) >0)
		SET @output = 'Yes'
	ELSE
		SET @output = 'No'
	return @output
END

select * from RESERVATION;
select * from GUEST_RESERVATION;
select * from ROOM;
select * from GUEST;
select * from ROOM_TYPE;

exec joinCurrentGuestRoom @guestFindId = 401,@guestId =405,@guestName = 'Itachi',@guestSurname = 'Uchiha', @guestAddress='Erzhanova 28',@guestDateOfBirth = '2001-07-18',@guestFamilyStatus = 'Married',@guestPhoneNumber= '123-032-1231',@guestEmail = 'i_uchiha@kbtu.kz', @dayOfArrival = '2021-07-01', @petNumber =0,@childNumber = 0, @gender= 'Male'
exec joinCurrentGuestRoom @guestFindId = 445,@guestId =200,@guestName = 'Gaara',@guestSurname = 'Rock', 
@guestAddress='Erzhanova 28',@guestDateOfBirth = '2001-07-18',@guestFamilyStatus = 'Married',
@guestPhoneNumber= '727-456-2233',@guestEmail = 'g_k@kbtu.kz', @dayOfArrival = '2021-05-18', @petNumber =0,
@childNumber = 0, @gender= 'Male'

CREATE FUNCTION checkAmountOfPeopleInRoom(@guestResId int,@roomType varchar(15))
returns varchar(10)
BEGIN
	DECLARE @output varchar(10)
	DECLARE @amountOfCurPeople int = (select count(*) from GUEST_RESERVATION where reservation_id = @guestResId)
	DECLARE @maxCapacityRoom int = (select room_max_capacity from ROOM_TYPE where room_type = @roomType)
	IF @amountOfCurPeople + 1 <=@maxCapacityRoom
	BEGIN
		SET @output = 'OK'
	END
	ELSE
	BEGIN
		SET @output = 'NOT OK'
	END
	return @output
END

CREATE FUNCTION checkPersonForHavingReservationByDate(@guestId int,@reservation int)
returns int
BEGIN
	DECLARE @arrivalDate date = (select TOP(1) arrival_date from RESERVATION where reservation_id = @reservation)
	DECLARE @departureDate date = (select TOP(1) departure_date from RESERVATION where reservation_id = @reservation)
	DECLARE @amountOfAccomodations int = 0
	SET @amountOfAccomodations = (select count(*) from RESERVATION res join GUEST_RESERVATION g_r on res.reservation_id = g_r.reservation_id 
	where res.reservation_status LIKE 'ACTIVE' and g_r.guest_id = @guestId and 
	((res.arrival_date<=@arrivalDate and res.departure_date>=@arrivalDate)or(res.arrival_date<=@departureDate and res.departure_date>=@departureDate)))
	return @amountOfAccomodations
END
select * from RESERVATION
select * from GUEST_RESERVATION
DROP PROCEDURE joinCurrentGuestRoom
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
		select 'Sorry,but there is no such person in Hotel!'
		return
	END
	ELSE
	BEGIN
		IF(dbo.getExistedGuest(@guestId) is NULL)
		BEGIN
			IF(dbo.checkForDataGuest(@guestId,@guestName ,@guestSurname ,@guestAddress ,@guestDateOfBirth,@guestFamilyStatus ,@guestPhoneNumber) Like 'No')
			BEGIN
				select 'Sorry, You did not fill all the data completely!'
				return
			END
			--ELSE
			--BEGIN
				--insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
			--END
		END
		
		DECLARE @guestReservationId int = NULL 
		SET @guestReservationId = (select TOP(1) res.reservation_id from RESERVATION res join GUEST_RESERVATION g_r 
		on res.reservation_id = g_r.reservation_id where res.reservation_status LIKE 'ACTIVE' AND g_r.guest_id = @guestFindId AND res.arrival_date = @dayOfArrival)
		
		IF (@guestReservationId is NULL)
		BEGIN
			select 'Sorry, but there is no such RESERVATION in Hotel !'
			return
		END
		
		DECLARE @neededRoomType varchar(15) = (select TOP(1) ro.room_type from RESERVATION res join ROOM ro on ro.room_id = res.reservation_room_id where reservation_id = @guestReservationId)
		IF(dbo.checkPersonForHavingReservationByDate(@guestId,@guestReservationId)>0)
		BEGIN
			select 'Sorry, but you have been already registered on this period of time !'
			return
		END
		DECLARE @capacityChecking varchar(10) = dbo.checkAmountOfPeopleInRoom(@guestReservationId,@neededRoomType)
		
		If(@capacityChecking LIKE 'NOT OK')
		BEGIN
			select 'Sorry, but there is too much people. You can not join them!'
			return
		END
		select 'YOU ARE JOINED!'
		IF(dbo.getExistedGuest(@guestId) is NULL)
		BEGIN
			insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
		END
		insert into GUEST_RESERVATION values(@guestReservationId,@guestId,@petNumber,@childNumber)
	END
END
DROP PROCEDURE joinCurrentGuestRoom 

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
select * from ROOM;
select * from GUEST;
select * from RESERVATION;
select * from GUEST_RESERVATION;
select * from room_audit;
delete from GUEST_RESERVATION where reservation_id = 20
delete from RESERVATION where reservation_id = 20
exec registerNewGuest @guestId = 401 , @guestName = 'Baruto' , @guestSurname = 'Uzumaki',@guestAddress = 'Tole Bi 59' ,@guestDateOfBirth = '1999-08-23',@guestFamilyStatus ='Single', @guestPhoneNumber = '929-291-1222', @guestEmail = 'b_uzumaki228@kbtu.kz', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-07-01', @dayOfDeparture = '2021-07-10', @prepayment = 50, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 403 , @guestName = 'Sakura' , @guestSurname = 'Haruno',@guestAddress = 'Erzhanova 39A' ,@guestDateOfBirth = '2002-11-12',@guestFamilyStatus ='Single', @guestPhoneNumber = '200-122-4311', @guestEmail = 's_haruno@kbtu.kz', @desiredRoomType ='single',  @desiredFloor = '2', @dayOfArrival= NULL, @dayOfDeparture = '2021-07-15', @prepayment = 120, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 444 , @guestName = 'Hinata' , @guestSurname = 'Huga',@guestAddress = 'HZ' ,@guestDateOfBirth = '2001-01-31',@guestFamilyStatus ='Single', @guestPhoneNumber = '243-432-1241', @guestEmail = 'h_hasdad@kbtu.kz', @desiredRoomType ='president',  @desiredFloor = NULL, @dayOfArrival= '2021-05-18', @dayOfDeparture = '2021-05-28', @prepayment = 250, @petNumber = 0, @childNumber = 0, @gender = 'Male'
exec registerNewGuest @guestId = 501 , @guestName = 'Hinata' , @guestSurname = 'Huga',@guestAddress = 'HZ' ,@guestDateOfBirth = '2001-01-31',@guestFamilyStatus ='Single', @guestPhoneNumber = '243-434-2934', @guestEmail = 'h_asdasda', @desiredRoomType ='family',  @desiredFloor = NULL, @dayOfArrival= '2021-09-21', @dayOfDeparture = '2021-09-23', @prepayment = 250, @petNumber = 0, @childNumber = 0, @gender = 'Female'
DROP PROCEDURE registerNewGuest
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
			select 'Sorry , You did not fill all the Information completely!'
			return
		END
		--ELSE
		--BEGIN
			--insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
		--END
	END
	
	iF (@dayOfArrival is NULL OR @dayOfDeparture is NULL or (@dayOfArrival <GetDate() or @dayOfArrival>@dayOfDeparture or @dayOfDeparture <GetDate()))
	BEGIN
		select 'Sorry , but you made a mistake in dates of Accomodation!'
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
		select 'Sorry , There is no available rooms By your Wish!'
		return
	END
	
	IF(@prepayment is NULL)
	BEGIN
		SET @prepayment = 0
	END
	
	IF( dbo.getNumberOfRegistersByIdAndDate(@guestId,@dayOfArrival,@dayOfDeparture) > 0 ) 
	BEGIN
		select 'Sorry ! However, you can not take more than One room for this period of time!'
		return
	END
	select 'Everything is Okay! '
	if(@foundGuestId is NULL)
	BEGIN
		insert into GUEST values (@guestId,@guestName,@guestSurname,@guestAddress,@guestDateOfBirth,@guestFamilyStatus,@guestPhoneNumber,@guestEmail,@gender)
	END
	DECLARE @newResId int 
	SET @newResId = (select TOP(1) reservation_id + 1 from RESERVATION order by reservation_id DESC )
	insert into RESERVATION values (@newResId,@dayOfArrival,@dayOfDeparture,@foundRoomId,GetDate(),@prepayment,'ACTIVE')
	insert into GUEST_RESERVATION values (@newResId,@guestId,@petNumber,@childNumber)
END
DROP TRIGGER tr_RoomUpdate
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

	select CONCAT('The room with type ',@roomType, ', ID = ',CAST(@roomIdNeeded as varchar), ' on the ',CAST(@roomFloor as varchar),' floor ','is BUSY from ',CAST(@startDate as varchar),' to ',CAST(@endDate as varchar))

END
select * from room_audit
CREATE FUNCTION getPrepayment(@reservationID int)
returns int
BEGIN
	DECLARE @foundPrepayment int = NULL
	SET @foundPrepayment = (select prepayment from RESERVATION where reservation_id = @reservationID)
	return @foundPrepayment
END
select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,res.reservation_date,
res.prepayment,res.reservation_status,g_r.guest_id,g_r.pet_number,g_r.child_number
from RESERVATION res join GUEST_RESERVATION g_r on res.reservation_id = g_r.reservation_id where g_r.guest_id = '402';
exec spCancelBooking @guestId = 402, @arrivalGuestDate ='2021-08-12' , @departureGuestDate = '2021-08-15'
select * from RESERVATION
select * from GUEST_RESERVATION;
select * from HOTEL_INVOICE;
select * from room_audit
DROP PROCEDURE spCancelBooking
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
		select 'Sorry, There is no such Reservation with this ID '
		return
	END

	DECLARE @dateDifference real = (DATEDIFF(minute,GetDate(),@arrivalGuestDate))
	IF (@dateDifference/60.0 >=24.0)
	BEGIN
		select 'Good Work!'
		DECLARE @foundPrepayment int
		SET @foundPrepayment = dbo.getPrepayment(@reservationId)
		
		UPDATE singleGlobalVariable
		SET singleVariable = 1;
		
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
		select 'Sorry, The remainded time is less than 24 to cancel Booking. You can not cancel Booking!'
		return
	END
END

DROP TRIGGER trForCancelBooking
CREATE TRIGGER trForCancelBooking
on GUEST_RESERVATION
AFTER DELETE
AS
BEGIN
	DECLARE @option int;
	SET @option = (select TOP(1) singleVariable from singleGlobalVariable)
	
	DECLARE @deletedReservationId int
	SET @deletedReservationId = (select TOP(1) reservation_id from deleted)
	DECLARE @cancelledRoomId int
	SET @cancelledRoomId = (select reservation_room_id from RESERVATION where reservation_id = @deletedReservationId)
	DECLARE @initialDate date
	SET @initialDate = (select arrival_date from RESERVATION where reservation_id = @deletedReservationId)
	DECLARE @endDate date
	SET @endDate = (select departure_date from RESERVATION where reservation_id = @deletedReservationId)
	
	IF(@option = 1)
	BEGIN

		DECLARE @foundPrepayment int
		SET @foundPrepayment = (select prepayment from RESERVATION where reservation_id = @deletedReservationId)

		UPDATE room_audit
		SET room_status = 'AVAILABLE',
		room_description = 'The room with id = ' + CAST(@cancelledRoomId as varchar) + ' was BUSY from ' + CAST(@initialDate as varchar)+ ' to ' + CAST(@endDate as varchar) + ' but now is available in this period'
		WHERE room_id = @cancelledRoomId AND room_date_beginning = @initialDate AND room_date_end = @endDate
	
		select('The reservation with ID = ' + CAST(@deletedReservationId as varchar) +
		' has been CANCELED and the Room with ID = ' + CAST(@cancelledRoomId as varchar) + ' on the period from ' + CAST(@initialDate as varchar) + ' to ' + CAST(@endDate as varchar) + ' became free.' 
		+ 'The sum with the amount of ' + CAST(@foundPrepayment as varchar) + ' has been successfully returned.' )
	END
	IF(@option = 2)
	BEGIN
		DECLARE @amountOfPeople int;
		SET @amountOfPeople = (select count(*) from deleted)
		IF(@amountOfPeople >1)
		BEGIN
			UPDATE room_audit
			SET room_status = 'AVAILABLE',
			room_description = 'The room with id = ' + CAST(@cancelledRoomId as varchar) + ' is free now. The guests decided to Evict themselve as well as leave it.' + ' The range of ACCOMODATION was ' + 
			CAST(@initialDate as varchar) + ' to ' +CAST(GetDate() as varchar) 
			WHERE room_id = @cancelledRoomId AND room_date_beginning = @initialDate AND room_date_end = @endDate
			select 'NO one'
		END
		IF(@amountOfPeople = 1)
		BEGIN
			DECLARE @cntPeople int = 0
			SET @cntPeople = (select count(*) from GUEST_RESERVATION as g_r where g_r.reservation_id = @deletedReservationId)
			if(@cntPeople = 0)
			BEGIN
				select 'One of the Guests left the room successfully. The Owner still leaves there.'
			END
			ELSE
			BEGIN
				UPDATE room_audit
				SET room_status = 'AVAILABLE',
				room_description = 'The room with id = ' + CAST(@cancelledRoomId as varchar) + ' is free now. The owner decided to leave it.' + ' The range of ACCOMODATION was ' + 
				CAST(@initialDate as varchar) + ' to ' +CAST(GetDate() as varchar) 
				WHERE room_id = @cancelledRoomId AND room_date_beginning = @initialDate AND room_date_end = @endDate
				select 'Owner is not here!'
			END
		END
	END
END

CREATE TABLE room_audit(
	number_audit integer identity(1,1) constraint pk_room_audit PRIMARY KEY,
	room_id integer not NULL,
	room_status varchar(20) not NULL,
	room_date_beginning date not NULL,
	room_date_end date not NULL,
	room_description varchar(200),
	constraint fk_room_audit_room_id FOREIGN KEY(room_id) REFERENCES ROOM(room_id)
);
CREATE TABLE HOTEL_INVOICE (
	hotel_invoice_id integer,
	hotel_invoice_reservation_id integer,
	hotel_invoice_guest_id integer,
	hotel_invoice_staff_id integer,
	hotel_invoice_total_cost integer,
	hotel_invoice_date date,
	hotel_invoice_payment_type varchar(4)
 );
 insert into HOTEL_INVOICE values(1,1,101,8,50,'2021-04-26','card')
 DROP TABLE HOTEL_INVOICE
 select * from RESERVATION
 select * from HOTEL_INVOICE

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
insert into RESERVATION values(9,'2021-06-11','2021-06-20',103,'2021-04-25',60,'ACTIVE');

alter Table RESERVATION
add prepayment int;

alter table RESERVATION
add reservation_status varchar(15);


CREATE TABLE GUEST_RESERVATION(
	reservation_id integer	not NULL,
	guest_id integer not NULL,
	pet_number integer,
	child_number integer,
	constraint fk_reserv_id_guest_reservation FOREIGN KEY(reservation_id) REFERENCES RESERVATION(reservation_id),
	--constraint fk_guest_id_guest_reservation FOREIGN KEY(guest_id) REFERENCES 
	constraint pk_guest_reservation PRIMARY KEY(reservation_id,guest_id)
);

select * from GUEST_RESERVATION;
insert into GUEST_RESERVATION values(1,101,NULL,NULL);
insert into GUEST_RESERVATION values(1,102,NULL,NULL);
insert into GUEST_RESERVATION values(2,103,NULL,1);
insert into GUEST_RESERVATION values(3,104,NULL,2);
insert into GUEST_RESERVATION values(4,105,1,NULL);
insert into GUEST_RESERVATION values(5,106,1,NULL);
insert into GUEST_RESERVATION values(6,107,NULL,NULL);
insert into GUEST_RESERVATION values(7,108,NULL,NULL);
insert into GUEST_RESERVATION values(8,109,NULL,NULL);
insert into GUEST_RESERVATION values(8,110,1,NULL);
insert into GUEST_RESERVATION values(9,101,NULL,NULL);

DELETE FROM GUEST_RESERVATION
WHERE reservation_id = 9

DELETE FROM RESERVATION
WHERE reservation_id = 9

create table ROOM_INVENTORY(
	room_type varchar(15) not NULL,
	inventory_code varchar(7) not NULL,
	room_inventory_quantity integer not NULL,
	constraint fk_room_type_room_inventory FOREIGN KEY(room_type) REFERENCES ROOM_TYPE(room_type),
	constraint fk_inventory_code_room_inventory FOREIGN KEY(inventory_code) REFERENCES INVENTORY(inventory_code),
	constraint pk_room_inventory PRIMARY KEY(room_type,inventory_code)
);

insert into GUEST values(103,'Anna','Brown','HelloWorld','1980-12-01','Divorced','000-000-0000','email@gmail.com','Female');

CREATE TABLE justTa(
numberOne int,
numberTwo int
);
INSERT into justTa values(100,200)
insert into justTa values(300,400)
insert into justTa values (400,500)

CREATE TRIGGER tr_just
ON justTa
AFTER DELETE
AS
BEGIN
	DECLARE @size int = (select count(*) from deleted)
	select * from justTa
	select *,@size from deleted
END
DROP TRIGGER tr_just
select * from justTa
DELETE from justTa
where numberOne <=400;



create table Accounts(
	login varchar(20) not null unique, 
	password varchar(10) not null,
	user_id int not null,
	user_type varchar(30) not null);

ALTER TABLE Accounts 
ADD user_status varchar(10)

UPDATE Accounts
SET user_status = 'offline'
select * from Accounts

insert into Accounts values
('guest', '1234', 110, 'guest'),
('EdwinS1', '1234', 1, 'receptionist'),
('JakeG9', '1234', 9, 'Hotel Manager'),
('DonnieT2', '1234', 2, 'Cleaner Manager'),
('CarolM214', '1234', 214, 'SPA Manager'),
('JorgeC215', '1234', 215, 'Gym Manager'),
('SvetlanaB213', '1234', 213, 'Restaurant Manager');

exec spEnterSystem @login = 'guest', @password = '1234';
exec spLogOutSystem @login = 'guest'
CREATE PROCEDURE spLogOutSystem
@login varchar(20)
AS
BEGIN
	UPDATE Accounts
	SET user_status = 'offline'
	where login = @login
END

CREATE PROCEDURE spEnterSystem
@login varchar(20),
@password varchar(10)
AS
BEGIN
	declare @foundPassword varchar(20) = NULL
	SET @foundPassword = (select password from Accounts where login = @login)
	IF (@foundPassword is NULL)
	BEGIN
		select 'Sorry, but you made a mistake in login!'
		return
	END

	IF(@foundPassword = @password)
	BEGIN
		select 'You are successfully Enterred!'
		UPDATE Accounts
		SET user_status = 'online'
		where login = @login
	END
	ELSE
	BEGIN
		select 'Sorry, but the Password is Incorrect!'
		return
	END
END