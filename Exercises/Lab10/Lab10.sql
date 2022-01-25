use Market;

select * from Customers;
select * from OrderItems;
select * from Orders;
select * from Products;

/*5 Procedures*/
/*   */
CREATE PROCEDURE spShowRegularOrNotCustomers
AS
BEGIN 
	select o.cust_id,c.cust_name,c.cust_address,c.cust_city,c.cust_email,count(*) amount_orders,
	CASE WHEN COUNT(*) >=2 THEN 'REGULAR CUSTOMER'
	ELSE 'SELDOM CUSTOMER'
	END AS customer_description 
	from Customers c join Orders o on c.cust_id = o.cust_id group by o.cust_id,c.cust_name,c.cust_address,c.cust_city,c.cust_email;
END

exec spShowRegularOrNotCustomers;

/*  */
CREATE PROCEDURE spGetPopularVendor
AS
BEGIN
	 DECLARE @avgNumb INT = (select (max(numb_goods) + min(numb_goods))/2 
	 from (select count(*) as numb_goods from products group by vend_id)a);
	 DECLARE @vendor_id varchar(10) = (select TOP(1) vend_id 
	 from Products group by vend_id having count(*) = @avgNumb);
	 exec spGetVendorInfo @ven_id = @vendor_id;
END

CREATE PROCEDURE spGetVendorInfo
@ven_id varchar(10)
AS
BEGIN
	select * from Vendors where vend_id = @ven_id;
END

exec spGetPopularVendor;

/* Show all the products whoes price is located between average price and second higher average price of the products. 
The second higher average price is located exactly in the middle of the mean value and max value price of the products.*/
CREATE PROCEDURE spGetThreFourthProducts
AS
BEGIN
	DECLARE @avgPrice real = (select avg(prod_price) from Products);
	DECLARE @maxPrice real = (select max(prod_price) from Products);
	DECLARE @secAveragePrice real = (select avg(prod_price) from Products where prod_price BETWEEN @avgPrice and @maxPrice) 
	select * from Products where prod_price between @avgPrice  and @secAveragePrice
END

exec spGetThreFourthProducts;

/*  */
CREATE PROCEDURE spShowLenVendEvenOddZip
AS
BEGIN
	select vend_id,vend_name,vend_zip, 
	CASE WHEN LEN(vend_zip)%2 =0 THEN 'Even Zip'
	ELSE 'Odd Zip'
	END AS zip_description
	from Vendors;
END

execute spShowLenVendEvenOddZip;

/*  */
CREATE PROCEDURE spShowOrderItemSumWithSumQuantityComparison
@number int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @orderItemSum int = (select sum(order_item) from OrderItems);
	DECLARE @sumQuantity int = (select sum(OrderItems.quantity) from OrderItems);
	PRINT 
	CASE WHEN @orderItemSum + @number < @sumQuantity THEN CONCAT(@orderItemSum + @number,' < ',@sumQuantity,' (is less than)')
	WHEN @orderItemSum + @number > @sumQuantity THEN CONCAT(@orderItemSum + @number,' > ',@sumQuantity,' (is higher than)')
	ELSE CONCAT(@orderItemSum + @number,' = ',@sumQuantity,' (is equal to) ')
	END;
END

execute spShowOrderItemSumWithSumQuantityComparison 1400;


/*7 Triggers*/

/*  */
CREATE TABLE tbCustomersAudit(
	id int IDENTITY(1,1),
	auditData varchar(max)
	);
DROP TABLE tbCustomersAudit

CREATE TRIGGER tr_CustomerForInsert
ON Customers
FOR INSERT 
AS
BEGIN
	DECLARE @id int
	Select @id = cust_id from inserted

	insert into tbCustomersAudit(auditData) values 
	('New Employee with ID = ' +
	CAST(@id as varchar) + ' is added at ' +
	cast(GetDate() as varchar))
END

DROP TRIGGER tr_CustomerForInsert
select * from Customers
CREATE TABLE NameSurname(
	namePerson varchar(50),
	surnamePerson varchar(50)
);
CREATE FUNCTION checkPerson(@name varchar(50),@surname varchar(50))
returns varchar(5)
BEGIN
	DECLARE @output varchar(5) = NULL
	DECLARE @number int = (select count(*) from NameSurname where namePerson = @name AND surnamePerson = @surname);
	if @number>0
	BEGIN
		SET @output = 'YES'
	END
	ELSE
	BEGIN
		SET @output  = 'NO'
	END
	return @output
END


IF dbo.checkPerson('hello','world') LIKE 'YES'
BEGIN
	UPDATE NameSurname
	SET namePerson = 'newName',surnamePerson = 'newSurname'
	where namePerson = 'oldName' AND surnamePerson = 'oldSurname'
	select 'EVERYTHING IS GOOD!'
END
ELSE
BEGIN
	select 'SORRY, THERE IS NO SUCH PERSON!'
END

IF dbo.checkPerson()
select * from NameSurname
insert into Customers values (1000000006,'Temirbolat Maratuly','Erzhanova 39A','Karagandy','HZ','100009','KAZ','Bred Pit','t_maratuly@kbtu.kz');
insert into Customers values (1000000007,'Tamerlan Kuankush','Erzhanova 39A','Karagandy','HZ','100009','KAZ','Bred Pit','t_kuankash@kbtu.kz');
insert into NameSurname values ('Name','Surname')
delete from Customers where cust_id = 1000000007;
select * from tbCustomersAudit
select * from Customers;
/*   */

CREATE TRIGGER tr_CustomerForDelete
ON Customers
FOR DELETE 
AS
BEGIN
	DECLARE @id int
	select @id = cust_id from deleted 

	insert into tbCustomersAudit values 
	('An existing customer with ID = ' +
	CAST(@id as varchar) + ' is deleted at ' +
	cast(GetDate() as varchar))
END
delete from Customers where cust_id = 1000000007;
select * from Customers;
DROP TRIGGER tr_CustomerForDelete
select * from Customers
/*  */
CREATE TRIGGER tr_CustomerUpdate
on Customers
FOR UPDATE
AS
BEGIN
	DECLARE @Id int
	DECLARE @oldName varchar(40), @newName varchar(40)
	DECLARE @oldAddress varchar(40), @newAddress varchar(40)
	DECLARE @oldCity varchar(20), @newCity varchar(20)
	DECLARE @oldState varchar(4), @newState varchar(4)
	DECLARE @oldZip varchar(10), @newZip varchar(10)
	DECLARE @oldCountry varchar(5), @newCountry varchar(5)
	DECLARE @oldContact varchar(40), @newContact varchar(40)
	DECLARE @oldEmail varchar(40), @newEmail varchar(40)

	DECLARE @finalString varchar(max)

	select * into #TempTable from inserted

	WHILE(EXISTS(select cust_id from #TempTable))
	BEGIN
		SET @finalString = ''
		SELECT TOP 1 @Id = cust_id, @newName = cust_name, @newAddress  = cust_address, @newCity = cust_city, @newState = cust_state,
		@newZip = cust_zip, @newCountry = cust_country, @newContact = cust_contact,@newEmail = cust_email from #TempTable

		SELECT @oldName = cust_name,@oldAddress = cust_address,@oldCity = cust_city,@oldState = cust_state,
		@oldZip = cust_zip, @oldCountry = cust_country, @oldContact = cust_contact, @oldEmail = cust_email from deleted where cust_id = @Id

		SET @finalString = 'Customer With  ID = ' + CAST(@Id as varchar) + ' changed'
		if (@oldName <> @newName )
				SET @finalString = @finalString + ' NAME from ' + @oldName + ' to ' + @newName
		if (@oldAddress <> @newAddress)
				SET @finalString = @finalString + ' ADDRESS from ' + @oldAddress + ' to '+ @newAddress
		if (@oldCity <> @newCity)
				SET @finalString = @finalString + ' CITY from ' + @oldCity + ' to ' + @newCity
		if (@oldState <> @newState)
				SET @finalString = @finalString + ' STATE from ' + @oldState + ' to ' + @newState
		if (@oldZip <> @newZip)
				SET @finalString = @finalString + ' ZIP from ' + @oldZip + ' to ' + @newZip
		if (@oldCountry <> @newCountry)
				SET @finalString = @finalString + ' COUNTRY from ' + @oldCountry + ' to ' + @newCountry
		if (@oldContact <> @newContact)
				SET @finalString = @finalString + ' CONTACT from ' + @oldContact + ' to ' + @newContact
		if (@oldEmail <> @newEmail)
				SET @finalString = @finalString + ' E-MAIL from ' + @oldEmail + ' to ' + @newEmail
		
		insert into tbCustomersAudit values (@finalString)

		Delete from #TempTable where cust_id = @Id
	END
END
DROP TRIGGER tr_CustomerUpdate
UPDATE Customers SET cust_name = 'Tamerlan Kuankush', cust_city = 'Almaty', cust_state = 'KZ', cust_zip = '100005',cust_email = 't_ku@kbtu.kz' where cust_id = 1000000006;
select * from tbCustomersAudit
/*   */
select * from Vendors;
select * from Products;

CREATE VIEW vWVendorsProductsDetails
AS
select p.prod_id,p.prod_name,p.amount,
p.prod_price,p.prod_desc,v.vend_name 
from Products p join Vendors v on v.vend_id  = p.vend_id;
DROP VIEW vWVendorsProductsDetails

CREATE TRIGGER trVWVendordProductsDetailsInsteadOfInsert
on vWVendorsProductsDetails
Instead Of Insert 
AS
BEGIN 
	DECLARE @vendId varchar(10)
	
	SELECT @vendId = vend_id
	from Vendors 
	join inserted 
	on inserted.vend_name = Vendors.vend_name  

	if (@vendId is NULL)
	BEGIN
		Raiserror('Invalid VENDOR NAME. TRE AGAIN PLEASE!',16,1)
		return
	END

	INSERT INTO Products(prod_id,vend_id,prod_name,amount,prod_price,prod_desc)
	SELECT prod_id,@vendId,prod_name,amount,prod_price,prod_desc 
	from inserted
END
DROP TRIGGER trVWVendordProductsDetailsInsteadOfInsert
insert into vWVendorsProductsDetails values('Burg4','Burger',20,'3.49','Very tasty burger','Bears R Us');
select * from Products

select * from vWVendorsProductsDetails;

/*   */
CREATE TRIGGER trChangePriceOfTheNewItemsWithDifferenceAfterUpdate
on PRODUCTS
AFTER UPDATE
AS
BEGIN
	DECLARE @oldPrice real
	DECLARE @newPrice real

	select @oldPrice = prod_price from deleted
	select @newPrice = prod_price from inserted
	DECLARE @difPrice real = ABS(@newPrice - @oldPrice)

	IF(@difPrice = 0)
	BEGIN
	Raiserror('YOU HAVE TO CHANGE THE PRICE. TRY AGAIN PLEASE!',16,1)
		return
	END
	UPDATE Products
	set prod_price = @difPrice
	where prod_id = (select prod_id from inserted)
END

UPDATE Products
SET prod_price = 6
where prod_id = 'BNBG01';
select * from Products

/*   */
CREATE TRIGGER trShowMessageVendorAfterInsert
on VENDORS
after insert
AS
BEGIN
	select 'The vendor is inserted successfully!'
END
DROP TRIGGER trShowMessageVendorAfterInsert
insert into Vendors values('BTW05','Temirlan Serikov','Tole Bi 59','Almaty','HZ','123123','KAZ')
select * from Vendors;

/*    */

select * from vWVendorsProductsDetails ;

CREATE TRIGGER trvWVendorsProductsDetailsInsteadDelete
on vWVendorsProductsDetails
instead of DELETE
as
BEGIN 
	DELETE from Products
	where prod_id in (select prod_id from deleted)
END

delete from vWVendorsProductsDetails where prod_id LIKE 'Burg1';



select * from Customers;
select * from OrderItems;
select * from Orders;
select * from Products;
select * from Vendors;
select * from tbCustomersAudit;
/*8 Functions*/

/* */
create function ownSumById
(@productId varchar(20))
returns numeric (9,2)
BEGIN
DECLARE @totalSumProductItem numeric (9,2);
select @totalSumProductItem =  sum(item_price) from OrderItems where prod_id = @productId;
return @totalSumProductItem;
END

select prod_id,dbo.ownSumById(Products.prod_id) as totalSoldPrice,prod_desc 
from products where dbo.ownSumById(prod_id) IS NOT NULL;

/* */
CREATE FUNCTION getIncreasedPriceByFiftyPercent
(@productId varchar(20))
returns numeric(9,2)
BEGIN
DECLARE @newPrice numeric(9,2);
select @newPrice = prod_price*1.5 from Products where prod_id = @productId;
return @newPrice;
END

select prod_id,prod_price as oldPrice,dbo.getIncreasedPriceByFiftyPercent(prod_id) as increasedCostByFiftyPercen  from Products;

/* */
CREATE FUNCTION getCustomerVendorsCombination()
returns TABLE 
AS
RETURN
(
select cust_id as person_id,cust_name as person_name,cust_address as person_address,cust_country as person_country from Customers
UNION
select vend_id as person_id,vend_name as person_name,vend_address as person_address,vend_country as person_country from Vendors
);

CREATE FUNCTION getPopularCountryAmongPeople()
returns varchar(5)
BEGIN
	DECLARE @popularCountry varchar(5) = 
	(select person_country from dbo.getCustomerVendorsCombination() group by person_country having count(*) = 
	(select max (totalNumberCitizens) as maxPeopleNumber from 
	(select count(*) as totalNumberCitizens from dbo.getCustomerVendorsCombination() group by person_country)a));
	return @popularCountry
END

select * from getCustomerVendorsCombination() where person_country = dbo.getPopularCountryAmongPeople()

/*  */

CREATE FUNCTION getNumberOfSignInPeopleTable(@name varchar (50),@sign varchar(5))
returns int
BEGIN
	DECLARE @signNumber int;
	select @signNumber = LEN(@name) - LEN(REPLACE(@name,@sign,'')) from getCustomerVendorsCombination()
	return @signNumber
END

CREATE FUNCTION getPeopleWithThreeWordsInName()
returns TABLE
AS
RETURN
(
	select person_id,person_name,person_address,person_country,
	dbo.getNumberOfSignInPeopleTable(person_name,' ') + 1 as numberOfWords 
	from getCustomerVendorsCombination() where dbo.getNumberOfSignInPeopleTable(person_name,' ') = 2 
);

select * from getPeopleWithThreeWordsInName();

/*   */

CREATE FUNCTION getTotalPrice(@orderId int,@itemId varchar(10))
returns MONEY 
BEGIN 
	DECLARE @money as MONEY;
	SELECT @money = quantity * item_price 
	from OrderItems where order_num = @orderId and prod_id = @itemId;
	return @money
END

select *,CONCAT(dbo.getTotalPrice(order_num,prod_id),' $')as total_price from OrderItems

/*  */
CREATE FUNCTION getAddressesWithoutNumbers(@address varchar(50))
returns varchar(50)
BEGIN
	DECLARE @newAddress varchar(50) = '';
	DECLARE @size int = len(@address);
	DECLARE @cnt int = 1;
	WHILE (@cnt<=@size)
	BEGIN
		if(SUBSTRING(@address,@cnt,1) NOT LIKE '[0123456789]%' AND @cnt <= @size)
			SET @newAddress = CONCAT(@newAddress,SUBSTRING(@address,@cnt,1))
		SET @cnt = @cnt + 1
	END
	return @newAddress;
END

CREATE FUNCTION compareCustomersVendorsAddresses(@custAddress varchar(50),@vendAddress varchar(50))
returns varchar(70)
BEGIN
	DECLARE @description varchar(70);
	select  @description = 
	CASE WHEN LEN(dbo.getAddressesWithoutNumbers(@custAddress)) > LEN(dbo.getAddressesWithoutNumbers(@vendAddress)) 
	THEN 'The ADDRESS of CUSTOMER is longer'
	WHEN LEN(dbo.getAddressesWithoutNumbers(@custAddress)) < LEN(dbo.getAddressesWithoutNumbers(@vendAddress)) 
	THEN 'The ADDRESS of VENDOR is longer'
	ELSE 'EQUAL ADDRESSES'
	END;
	return @description;
END

select CUSTOMERS.cust_id,CUSTOMERS.cust_name,CUSTOMERS.cust_address,dbo.getAddressesWithoutNumbers(cust_address) as addressWithoutNumbersCust,
LEN(dbo.getAddressesWithoutNumbers(cust_address)) as lengthWithoutNumbersCust
,VENDORS.vend_id,VENDORS.vend_name,VENDORS.vend_address,dbo.getAddressesWithoutNumbers(vend_address) as addressWithoutNumbersVend,
LEN(dbo.getAddressesWithoutNumbers(vend_address)) as lengthWithoutNumbersVend,
dbo.compareCustomersVendorsAddresses(cust_address,vend_address) as CustomerVSVendorSummary from Customers,Vendors;

/*  */
CREATE FUNCTION isItLeapYear(@curYear int)
returns varchar(40)
BEGIN
	DECLARE @year varchar(40);
	select @year = CASE 
	WHEN (@curYear % 4 = 0 AND @curYear %100 <> 0) OR (@curYear % 400 = 0 ) THEN 'LEAP YEAR '
	ELSE 'NOT LEAP YEAR'
	END;
	return @year;
END

select order_num,order_date,dbo.isItLeapYear(CAST(SUBSTRING(cast(order_date AS varchar),1,4) AS int)) as year_description,cust_id from orders;

select * from Vendors
/*  */
CREATE FUNCTION getCorrectZipNumbers(@oldZip varchar(20))
returns varchar(20)
BEGIN
	DECLARE @sizeZip int = len(@oldZip);
	DECLARE @cnt int = 1;
	DECLARE @newZip varchar(20) = ''; 
	WHILE (@cnt <= @sizeZip)
	BEGIN
		if(SUBSTRING(@oldZip,@cnt,1) LIKE '[0123456789]%')
			SET @newZip = CONCAT(@newZip,SUBSTRING(@oldZip,@cnt,1))
		SET @cnt = @cnt + 1
	END
	return @newZip;
END

CREATE FUNCTION sumOfZipNumbers(@curZip varchar(20))
returns int
BEGIN
	DECLARE @sumNumbers int = 0;
	DECLARE @newZip varchar(20) = dbo.getCorrectZipNumbers(@curZip);
	DECLARE @counter int = 1;
	DECLARE @newZipSize int = len(@newZip);
	while (@counter <= @newZipSize)
	BEGIN
		SET @sumNumbers = @sumNumbers + CAST(SUBSTRING(@newZip,@counter,1) AS tinyint)
		SET @counter = @counter + 1;
	END
	return @sumNumbers;
END

CREATE VIEW people AS
select cust_id as person_id,cust_name as person_name,cust_zip as person_zip from Customers
union
select vend_id as person_id,vend_name as person_name,vend_zip as person_zip from Vendors;

select *, dbo.sumOfZipNumbers(CAST(people.person_zip as varchar)) from people;












CREATE PROCEDURE showPidor
@name varchar(20),
@age int
AS
BEGIN
	print 'The person with name ' + @name +' and age ' + CAST(@age as varchar) +' is pidor'
END
DROP  PROCEDURE showPidor
showPidor @name = 'Assanali', @age = 19
exec showPidor 'Assanali',19

CREATE TABLE info(
	number int,
	firstName varchar(25)
);

insert into info values (2,'Assanali')
select * from info

CREATE TRIGGER showWhoAdded
ON info
AFTER insert
AS
BEGIN
	select * from inserted
	select * from deleted 
END

UPDATE info 
SET firstName = 'Temirbolat'
where number = 1

CREATE TRIGGER showUpdatedUser
ON info
AFTER UPDATE
AS
BEGIN
	select * from inserted
	select * from deleted 
END

select * from inserted