create table EMPLOYEES(     /* The line shows the request to create a table with the variables for each columns*/
    EMPLOYEE_ID integer,    /* Each colum has own name and data type */
    FIRST_NAME varchar(20),
    LAST_NAME varchar(20),
    EMAIL varchar(40),
    PHONE_NUMBER varchar(30),
    HIRE_DAT date,
    JOB_ID varchar(20),
    SALARY integer
);
select * from EMPLOYEES;

ALTER TABLE EMPLOYEES
ADD department_id integer;
/*Add a new Column without any variables with inteder type*/
UPDATE EMPLOYEES
set department_id = 110
WHERE job_id like 'AC%';
/*Fill in the column 'department_id' doing it each time for every given condition */

select * from employees where salary > (select avg(salary) from employees group by JOB_ID having JOB_ID like 'IT%');
/*A query to display all the information about employees whose salaries are higher than the average salary of programmers*/

select * from employees where length(FIRST_NAME) = (select max(length(first_name)) from employees);
/*Query to display the list of employees with the longest name*/

select employee_id,first_name,last_name, salary from EMPLOYEES where SALARY = (select max(salary) from employees);
/*Query to display the id, first name, last name and salary of the employee with the
maximum salary*/

select  * from departments where manager_id = (select EMPLOYEE_ID from employees where FIRST_NAME like 'Jennifer');
/*Query to display the information of department managed by Jennifer.*/

select AVG(salary)  from employees group by JOB_ID having count(JOB_ID)  = (select max(job_numb) from (select COUNT(JOB_ID) job_numb from employees group by JOB_ID)a) ;
/*Query to display the average salary for the most numerous department.*/

select job_id from employees group by job_id having min(SALARY) > (select Min(salary) from employees where EMPLOYEES.department_id = 50) and JOB_ID not like 'SH%';
/*Query to display in which departments the minimum salary is greater than the
minimum salary in the 50th department.*/

select departments.department_name, employees.first_name
from employees join departments
on departments.department_id = EMPLOYEES.department_id;
/*Query to display the department names for each employee using JOIN*/

select * from departments where department_id not in (select department_id from EMPLOYEES);
/*Query to display all departments in which there is no employee.*/

select j.gra, e.first_name,e.salary
from job_grades j join employees e
on e.salary BETWEEN  j.lowest_sal AND j.highest_sal;
/*. Write a query to display the JOB_Grade for each employee.*/

select count(department_id),EMPLOYEES.department_id from employees group by EMPLOYEES.department_id;

select departments.department_name, count(EMPLOYEES.EMPLOYEE_ID) as employees_number
from departments Left Outer Join  employees
on departments.department_id = EMPLOYEES.department_id
group by  departments.department_name,department_name
order by employees_number;
/*Query to display the department name and number of employees in each of the
department.*/

select e.last_name, e.first_name, e.job_id,d.department_name,d.department_id,e.HIRE_DAT
from employees e join departments d
on d.department_id = e.department_id
where e.hire_dat >='1995-01-01' and e.hire_dat <='2021-02-11';
/*Write a query to display the last name, first name, job title, department name of employee,
  and hire date for all the jobs which started on or after 1st of January,
  1995 and ending with on or before 11th of Febraury, 2021.*/

select e.first_name,l.loc_name
from employees e join departments d
on e.department_id = d.department_id
left join  locations l
on d.location_id = l.loc_id;
/*Query to display the name of the cities for each employee*/

select e.first_name,l.loc_name,e.SALARY/10 as month_contributions, e.SALARY/10 *12 as year_contributions
from employees e join departments d
on e.department_id = d.department_id
join  locations l
on d.location_id = l.loc_id;
/*Query to display the name of the cities for each employee and show their
  monthly and annual mandatory pension contributions (10% of the salary)*/

select l.loc_name,avg(e.SALARY) as average_salary
from employees e join departments d
on e.department_id = d.department_id
left join  locations l
on d.location_id = l.loc_id
group by l.loc_name;
/*Query to display the average salary for each city*/

select *
from employees e join departments d
on e.department_id = d.department_id
left join  locations l
on d.location_id = l.loc_id
where e.salary = (select max(salary) from EMPLOYEES where department_id = 20);
/*Query to display all the information about the manager with the highest salary*/

select * from employees where salary = (select Max(salary) from employees where
salary < (select Max(salary) from (select * from employees where salary < (select Max(salary) top_salary from EMPLOYEES))a));
/*Query to display data about the employee who has the third maximum salary.*/

select * from employees where employees.employee_id NOT IN (select manager_id from departments where manager_id is not NULL);
/*Query to display all employees who are not managers*/

select * from employees where employees.department_id in
(select department_id from departments where location_id = (select loc_id from locations where loc_name like 'Karagandy'));
/*Query to display all the information about the employees whose department location is Karaganda */

select e.first_name,l.loc_name
from employees e join departments d
on e.department_id = d.department_id
left join  locations l
on d.location_id = l.loc_id
where e.employee_id = 124;
/*Query to display the city of the employee whose ID = 124*/

select manager_id,count(EMPLOYEE_ID)-1 as number_subardinates
from employees e join departments d
on e.department_id = d.department_id
group by manager_id;
/*Query to display the number of subordinates for each manager*/

create table countries(
    country_id varchar(5),
    country_name varchar(20),
    region_id integer
);

insert into countries values('KAZ','Kazakhstan','9');
insert into countries values('RUS','Russia',2);
insert into countries values('CND','Canada',3);
insert into countries values('JPN','Japan',1);

select * from countries;

select concat(e.last_name,' ',e.first_name) full_name, c.region_id,c.country_name
from employees e join departments d
on e.department_id = d.department_id
join  locations l
on d.location_id = l.loc_id
join countries c
on l.country_id = c.country_id;
/*Query to display the full names of employees (last name + first name), separated by only one
space, into a common column, with ID and name of the country presently where (s)he is working*/

select e.EMPLOYEE_ID,concat()
from employees e join departments d
on e.department_id = d.department_id
join  locations l
on d.location_id = l.loc_id
join countries c
on l.country_id = c.country_id;
/*Query to display the country name, city, and number of those departments where at least 2 employees are working*/

select first_name, last_name from EMPLOYEES
where salary > (select salary from EMPLOYEES where EMPLOYEE_ID = 124);
/*Query to display the name ( first name and last name ) for those employees who gets more salary than the employee whose id is 124.*/

select avg(salary) average_salary from employees
group by EMPLOYEES.department_id
having count(EMPLOYEES.department_id) =
(select max(number_clients) from
(select count(department_id) number_clients from employees group by  EMPLOYEES.department_id)a);
/*Query to display the average salary for the most numerous department.*/

select department_name,department_id from departments
where department_id in
(select EMPLOYEES.department_id from EMPLOYEES
group by EMPLOYEES.department_id having min(salary) > (select min(salary)
from EMPLOYEES where EMPLOYEES.department_id = 50));
/*Query to display in which departments the minimum salary is greater than the minimum salary in the 50th department*/

select max(average_salary) maximum_average_salary
from (select AVG(salary) average_salary from EMPLOYEES group by EMPLOYEES.department_id)a;
/*Query to display the maximum average salary by department*/

select e.first_name,e.last_name,d.department_name
from EMPLOYEES e join departments d
on e.department_id = d.department_id;
/*Query to display the department names for each employee using JOIN*/

select * from employees where salary =
(select max(SALARY) from employees where employees.employee_id in
(select manager_id from departments where manager_id is not NULL));
/*Query to display all the information about the manager with the highest salary.*/

select d.manager_id,count(EMPLOYEE_ID)
from employees e right join departments d
on e.department_id = d.department_id
where (manager_id is not NULL AND e.EMPLOYEE_ID != d.manager_id) OR manager_id = 100
group by manager_id;
/*Query to display the number of subordinates for each manager*/

select * from employees order by EMPLOYEE_ID;

select *
from employees e right join departments d
on e.employee_id = d.manager_id
where (e.department_id is not NULL AND d.department_id is not NULL)
  AND (e.department_id != d.department_id);
/*Query to display all the information about a manager who is also a subordinate.*/

select department_id from employees where EMPLOYEE_ID in(142,144);
/*Obtain department id of the employees 142 and 144 to see are they the same or not*/
select * from employees where EMPLOYEES.department_id = 50
AND employees.employee_id not in ((select manager_id from departments where department_id = 50),142,144);
/*Since we found that 142 and 144 employees work together we also found the manager
  of that department and displayed the info about only the collegues in the same department*/
select c.country_name as country,l.loc_name as city,count(department_id) as department_number
from countries c join locations l
on c.country_id = l.country_id
join departments d
on d.location_id = l.loc_id
where department_id in
(select department_id from employees
group by department_id
having count(department_id) > 1)
group by country_name,loc_name;
/*Query to display the country name, city, and number of those departments where at least 2 employees are working*/

select * from countries;
select * from employees;
select * from LOCATIONS;
select * from departments;
select * from job_grades;
create table departments( /* The line creates table with the columns that have data types correspond to them*/
    department_id integer,
    department_name varchar(25), /*The length of the word can be no more the 25 */
    manager_id integer,
    location_id integer
);

insert into departments values ('10','Administration','200','1700'); /* Lines from the 24 to 31 insert (add) new rows with the data to the table*/
insert into departments values ('20','Marketing','201','1800');
insert into departments values ('50','Shipping','124','1500');
insert into departments values ('60','IT','103','1400');
insert into departments values ('80','Sales','149','2500');
insert into departments values ('90','Executive','100','1700');
insert into departments values ('110','Accounting','205','1700');
insert into departments values ('190','Contracting',NULL,'1700');

select * from departments; /* Here we shows all the columns with the filled information from the table "departments"*/

create table job_grades(   /* The line creates a table with the columns that have data types*/
    gra varchar(1),         /*The length of the word is only 1*/
    lowest_sal integer,
    highest_sal integer
);

insert into job_grades values ('A','1000','2999');  /* Lines from the 41 to 46 insert new rows with the data to the table*/
insert into job_grades values ('B','3000','5999');
insert into job_grades values ('C','6000','9999');
insert into job_grades values ('D','10000','14999');
insert into job_grades values ('E','15000','24999');
insert into job_grades values ('F','25000','40000');

select * from job_grades; /*Request to show all the columns from the "job_grades"*/

create Table LOCATIONS(
    loc_id integer,
    loc_name varchar(20),
    country_id varchar(20)
);
insert into LOCATIONS values(1700,'Karagandy','KAZ');
insert into LOCATIONS values(1800,'Moscow','RUS');
insert  into LOCATIONS values(1500,'Toronto','CND');
insert into LOCATIONS values(1400,'Tokyo','JPN');
insert into LOCATIONS values(2500,'Almaty','KAZ');
select  * from LOCATIONS;
select * from departments;
select * from job_grades;
select * from employees;

/*Lab 3 Part 1*/
select * from employees;
alter table employees
add column  emp_id serial ;
alter table employees add constraint pk_employees primary key (emp_id);
/* Primary key – for new column EMP_ID */
alter table employees add unique (email);
/* Unique - for Email */
alter table employees alter column first_name set not null;
/*Not Null – for First_Name*/
alter table employees add check ( salary > 1000 );
/*Check >1000 - for Salary 	*/
alter table employees add check( length(last_name) < 15);
/*The length of the last name < 15 */
insert into employees values (105,'Temirbolat','Maratuly','t_maratuly@kbtu.kz','515.123.2132','2001-01-31','IT_PROG',35000,105000,60);
/*Add a new Employee Temirbolat to the existed table and satisfy the constrainsts*/
insert into employees values (105,'Henry','Wolf','h_wolf@kbtu.kz','123.412.2133','2012.11.10','SA_MAN',1700,80,default);
/*Here we obtain error because the row with the same primary key value is already there*/
insert into employees values (208,NULL,'Wolfeschlegelstein','t_maratuyly@kbtu.kz','515.213.1233','2013.11.14','SA_MAN',700,2100,80,22);
/*Here name is null ,last_name length is more than 15, already the same email exists, and the same emp_id is token for primary key*/

/*Part 2 DEPARTMENTS*/
alter table departments add column  DEP_ID serial;
alter table departments add constraint pk_departments primary key (DEP_ID);
/*Primary key – for new column DEP_ID*/
alter table departments add unique (department_name);
/*Unique - for Department_Name*/
alter table departments alter column  location_id set not null ;
/*Not Null – for Location_Id*/

alter table employees drop constraint  pk_employees;
/*Delete the previous primary key constraint to add another*/
alter table employees add constraint  pk_employee primary key (employee_id);
/*Add another primary key into employees table*/
alter table departments add constraint  dep_manager_fk foreign key (manager_id) REFERENCES employees(EMPLOYEE_ID);
/* Foreign key - for Manager_ID with reference to Employee_ID from Employees*/
select * from departments;

alter table departments drop constraint  pk_departments;
alter table departments add constraint  pk_departments primary key (department_id);
alter table employees add constraint dep_id_fk foreign key (department_id) REFERENCES departments(department_id);
/*Foreign key – for Department_ID (Employees table) with reference to Department_ID from Departments table */

insert into departments values (190,'Temir_Adam','105',1700,1);
/*Error that is correspondent with the existed value for primary key*/
insert into departments values (200,'Administration', 105,1700,default);
/*Error that appeared because of the existed Administration department_name*/
insert into  departments values (200,'Engineering',105,NULL,default);
/*Error appeared since the location_id can not be NULL*/
ПОДУМАТЬ НАД ЗАПРОСОМ ПРО ОШИБКУ НАД ФОРЭЙН КЕЙ,если надо будет

/*Part 3 GRADES*/
alter table job_grades add constraint  pk_job_grades primary key (gra);
/*Primary key - for GRA*/

alter table job_grades alter column lowest_sal set not null;
alter table job_grades alter column highest_sal set not null;
/*Not Null – for Lowest_Sal and Highest_Sal*/

alter table job_grades add check ( length(gra) <2 );
/*The constraint that there can not be double marks as A+, B- and so on*/

insert into job_grades values ('G',41000,49999);
select * from job_grades;

/*Part 4 Locations*/

alter table locations add constraint pk_locations primary key (loc_id);
/*Primary key – for Location_ID*/

alter table locations add unique (loc_name);
/*Unique - for  Location_Name*/

alter table departments add constraint dep_location_id_FK foreign key (location_id) references locations(loc_id);
/* Foreign key – for Location_ID (Departments table) with reference to Location_ID from Locations*/
select * from locations;

/*Part 5 Own Table */
CREATE TABLE films(
  code varchar(5) constraint firstkey PRIMARY KEY,
  title varchar(40) NOT NULL,
  did integer unique,
  date_prod date,
  len real,
  constraint  con1 CHECK ( len>1.3 )
);

insert into films values (1,'Your Name',10,'2016-02-15',2.3);
/*Error comes because the primary key 1 is already used*/
insert into films values (2,NULL,10,'2016-02-14',2.3);
/*Error appears because the title can not be NULL*/
insert into films values (2,'Your Name',9,'2016-02-15',2.3);
/*Error appears since the did column is the same as for Star Wars*/
insert into films values (2,'Your Name', 10,'2016-02-15',1.0);
/*Error is here because the length of the film must be higher than 1.3 */
select * from films;
select * from employees;