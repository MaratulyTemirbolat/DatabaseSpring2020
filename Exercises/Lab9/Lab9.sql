use labNineTrial;



/* Create a stored procedure that adds the missing data to the «Bank scheme»
database.*/
CREATE PROCEDURE spFillNullTable
AS
BEGIN
	DECLARE @neededID INT =0
	WHILE @neededID < 19
	BEGIN
		SET @neededID = @neededID + 1
		UPDATE EMPLOYEE
		SET SUPERIOR_EMP_ID = FLOOR(RAND()*(18)+1)
		where EMP_ID = @neededID
	END
	select * from EMPLOYEE
END 
exec spFillNullTable

/* Create a stored procedure that changes the datetime data type to date for all 
the corresponding columns of the «Bank scheme». */

CREATE PROCEDURE spChangeDataType
AS
BEGIN
	ALTER TABLE ACC_TRANSACTION
	ALTER COLUMN FUNDS_AVAIL_DATE date
	ALTER TABLE ACC_TRANSACTION
	ALTER COLUMN TXN_DATE date

	ALTER TABLE ACCOUNT
	ALTER COLUMN LAST_ACTIVITY_DATE date
	ALTER TABLE ACCOUNT
	ALTER COLUMN OPEN_DATE date

	ALTER TABLE BUSINESS
	ALTER COLUMN INCORP_DATE date

	ALTER TABLE EMPLOYEE
	ALTER COLUMN START_DATE date

	ALTER TABLE INDIVIDUAL
	ALTER COLUMN BIRTH_DATE date

	ALTER TABLE OFFICER
	ALTER COLUMN START_DATE date

	ALTER TABLE PRODUCT
	ALTER COLUMN DATE_OFFERED date
END
exec spChangeDataType
select * from ACCOUNT;
/*Create a stored procedure that counts the number of accounts for each bank 
customer and returns either ‘None’, ‘1’, ‘2’ or ‘3+’. The result set should 
include the customer identification number, the customer type and the 
number of accounts*/

CREATE PROCEDURE spCounterAccounts
AS
BEGIN
	select cus.CUST_ID,cus.CUST_TYPE_CD,
	CASE WHEN COUNT(cus.CUST_ID) = 0 THEN 'NONE' 
	WHEN COUNT(cus.CUST_ID) = 2 THEN '2'
	WHEN COUNT(cus.CUST_ID) = 1 THEN '1'
	ELSE '3+' 
	END AS NUM_ACC 
	from ACCOUNT ac join CUSTOMER cus on ac.CUST_ID = cus.CUST_ID 
	group by cus.CUST_ID,cus.CUST_TYPE_CD; 
END
exec spCounterAccounts

/*Create a stored procedure that uses two CASE expressions to generate two 
output columns, one to show whether the customer has any checking 
accounts and the other to show whether the customer has any savings 
accounts. If the customer has the account, print ‘Y’, otherwise print ‘N’. The 
result set should include the following information: the customer ID, their 
home address, the existence of checking accounts and the existence of 
savings accounts.*/

CREATE PROCEDURE spAccountInfo
AS
BEGIN
	select cus.CUST_ID,cus.ADDRESS,
	CASE WHEN cus.CUST_ID in (select cus.CUST_ID from CUSTOMER cus join ACCOUNT ac on ac.CUST_ID = cus.CUST_ID where ac.PRODUCT_CD = 'CHK') THEN 'Y'
	ELSE 'N'
	END AS CHECKING_EXISTENCE,
	CASE WHEN cus.CUST_ID in (select cus.CUST_ID from CUSTOMER cus join ACCOUNT ac on ac.CUST_ID = cus.CUST_ID where ac.PRODUCT_CD = 'SAV') THEN 'Y'
	ELSE 'N' 
	END AS SAVING_EXISTENCE from CUSTOMER cus join ACCOUNT ac on ac.CUST_ID = cus.CUST_ID 
	group by cus.CUST_ID,cus.ADDRESS;

END
exec spAccountInfo

/*Create a stored procedure that declares a variable and set it to the count of all
PRODUCT_TYPE_CD in the Product_Type table. If the count is greater than 
or equal to 3, the stored procedure should display a message that says, “The 
number of PRODUCT_TYPE_CD is greater than or equal to 3”.
Otherwise, it should say, “The number of PRODUCT_TYPE_CD is less than 
3”.*/

CREATE PROCEDURE spCountProductType
AS
BEGIN
	DECLARE @size INT = (select COUNT(p.PRODUCT_TYPE_CD) from PRODUCT_TYPE p)
	PRINT 
	CASE WHEN @size >=3 THEN 'The number of PRODUCT_TYPE_CD is greater than or equal to 3'
	ELSE 'The number of PRODUCT_TYPE_CD is less than 3'
	END;
END
exec spCountProductType


/*Create a stored procedure that uses two variables to store:
a) the count of all of the customers in the Customer table;
b) the average avail balance for each customer. 
If the customers count is greater than or equal to 13, the stored procedure 
should display a result set that displays the values of both variables. Otherwise, the 
procedure should display a result set that displays a message that says, “The number 
of customers is less than 13”.*/

CREATE PROCEDURE spBalanceToCustomer
AS
BEGIN
	DECLARE @sizeCustomers INT = (SELECT COUNT(CUST_ID) from CUSTOMER)
	DECLARE @avgRemaind REAL = (SELECT AVG(AVAIL_BALANCE) as Average_balance from ACCOUNT )
	PRINT 
	CASE WHEN @sizeCustomers >=13 THEN CONCAT(@sizeCustomers,' and ',@avgRemaind)
	ELSE 'The number of customers is less than 13'
	END
END
exec spBalanceToCustomer

/*Create a stored procedure that calculates the common factors between 15 and
30. This procedure should display a string that displays the common factors 
in this form:
Common factors of 15 and 30: 1 3 5 15*/

CREATE PROCEDURE spShowCommonFactors
AS
BEGIN
	DECLARE @cnt int = 1
	DECLARE @answer varchar(150) = 'Common factors of 15 and 30:'

	WHILE (@cnt <=15)
	BEGIN
		IF(15%@cnt = 0 AND 30%@cnt = 0)
			SET @answer = CONCAT(@answer,' ',@cnt)
		SET @cnt = @cnt + 1
	END
	print @answer
END
exec spShowCommonFactors


/* Create a stored procedure that shows all numeric characters from the entire 
string. You can use the ADDRESS columns in the «Bank scheme» database 
or any row of your choice.*/

CREATE PROCEDURE spShowNumbers
AS
BEGIN
	select SUBSTRING(ADDRESS,PATINDEX('%[0-9]%',ADDRESS),CHARINDEX(' ',ADDRESS)-1) as num from BRANCH;
END
exec spShowNumbers

/*Create a stored procedure for the «Bank scheme» database of your choice. 
Condition: the procedure must be encrypted.*/
CREATE PROCEDURE spShowFullNameDescription
WITH Encryption
AS
BEGIN
DECLARE @maxAppearance INT = 
(select MAX(LEN(LOWER(CONCAT(FIRST_NAME,' ',LAST_NAME))) - 
LEN(replace(LOWER((CONCAT(FIRST_NAME,' ',LAST_NAME))),'a',''))) as max_a_appearance 
from INDIVIDUAL) 

select FIRST_NAME,LAST_NAME,
CASE WHEN LEN(LOWER(CONCAT(FIRST_NAME,' ',LAST_NAME))) - 
LEN(replace(LOWER((CONCAT(FIRST_NAME,' ',LAST_NAME))),'a','')) < FLOOR(RAND()*@maxAppearance + 1)
THEN 'tiny amount of (a) letter appearances'
ELSE 'Enough amount of repetitions'
END AS a_description, @maxAppearance as max_appearance
from OFFICER;
END

exec spShowFullNameDescription

/*Create two stored procedures for the «Bank scheme» database. Condition: 
one procedure must call another*/

CREATE PROCEDURE spFindPopularTypeAccount
AS
BEGIN
	DECLARE @maxNumb INT = (select max(numb_account) from  (select COUNT(ACCOUNT_ID) as numb_account from ACCOUNT group by PRODUCT_CD)a);
	DECLARE @popType varchar(10) =( select TOP(1) PRODUCT_CD from ACCOUNT group by PRODUCT_CD having COUNT(ACCOUNT_ID) = @maxNumb);
	exec spShowAccounts @typeAccount = @popType
END

CREATE PROCEDURE spShowAccounts
@typeAccount varchar(10)
AS
BEGIN
	select * from ACCOUNT where PRODUCT_CD = @typeAccount;
END

exec spFindPopularTypeAccount

select * from ACC_TRANSACTION;
select * from ACCOUNT;
select * from BRANCH;
select * from BUSINESS;
select * from CUSTOMER;
select * from DEPARTMENT;
select * from EMPLOYEE;
select * from INDIVIDUAL;
select * from OFFICER;
select * from PRODUCT;
select * from PRODUCT_TYPE;


 
