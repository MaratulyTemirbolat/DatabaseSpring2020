use Universities;

/*
Aim  : 1) 5 easy queries
		 2) 5 Join queries
		 3) 5 subquery requests
		 4) 5 Functions requests
		 
Requirenments :  1) Views
				 2) Index
				 3) Transactions
*/
select * from STUDENT;
select * from EXAM_MARKS;
select * from SUBJ_LECT;
select * from SUBJECT;
select * from UNIVERSITY;
select * from Lecturer;

/* Five Easy Requests*/
/*Show all the students who study at Moscow*/
CREATE VIEW place_stud_education AS
select s.STUDENT_ID,s.SURNAME,s.NAME,s.STIPEND,s.KURS,s.CITY as BornCity,s.BIRTHDAY,s.UNIV_ID,u.UNIV_NAME,u.CITY 
from STUDENT s join UNIVERSITY u on s.UNIV_ID = u.UNIV_ID;

select * from place_stud_education where CITY = 'Москва';

/*Show the students who passed the exam in 2000 and took the mark higher than average */
CREATE VIEW student_marks as
select s.STUDENT_ID,s.SURNAME,s.NAME,s.STIPEND,s.KURS,s.CITY,s.BIRTHDAY,s.UNIV_ID,e_m.EXAM_ID,e_m.SUBJ_ID,e_m.MARK,e_m.EXAM_date
from student s join exam_marks e_m on s.STUDENT_ID = e_m.STUDENT_ID;

CREATE VIEW student_subj_marks as
select s_m.STUDENT_ID,s_m.SURNAME,s_m.NAME,s_m.STIPEND,s_m.KURS,s_m.CITY,s_m.BIRTHDAY,s_m.EXAM_ID,s_m.SUBJ_ID,s_m.MARK,sub.SUBJ_NAME,s_m.EXAM_date
from student_marks s_m join SUBJECT sub on s_m.SUBJ_ID = sub.SUBJ_ID;


CREATE VIEW average_subj_marks as 
select AVG(MARK) as average_mark,s.SUBJ_NAME, s.SUBJ_ID from SUBJECT s join EXAM_MARKS e_m on s.SUBJ_ID = e_m.SUBJ_ID group by s.SUBJ_ID,s.SUBJ_NAME;

CREATE INDEX IX_marks ON EXAM_MARKS (MARK);

set statistics time on

select s_s_m.NAME,s_s_m.SURNAME,s_s_m.SUBJ_NAME,s_s_m.MARK,a_s_m.average_mark, s_s_m.EXAM_date 
from student_subj_marks s_s_m join average_subj_marks a_s_m on s_s_m.SUBJ_ID = a_s_m.SUBJ_ID 
where s_s_m.MARK>a_s_m.average_mark AND (s_s_m.EXAM_date>='2000-01-01' AND s_s_m.EXAM_date<='2000-12-31' );

set statistics time off

DROP INDEX EXAM_MARKS.IX_marks;

/* ON TRANSACTION */

begin transaction t1;

update STUDENT
SET STIPEND = STIPEND*1.2
where KURS = 2;

update STUDENT
set STIPEND = STIPEND * 1.25
where KURS = 3;

commit transaction t1;

select STUDENT_ID,SURNAME,NAME,KURS,STIPEND from STUDENT;

/*Show the firts 3 universities with the best rating*/

select TOP(3) UNIVERSITY.UNIV_NAME,UNIV_ID,RATING from University order by RATING desc;

/*Show all the Lectures who teach more than 1 subject*/
CREATE VIEW lec_subject as
select LECTURER_ID,COUNT(SUBJ_ID) as takenSubjects from SUBJ_LECT group by LECTURER_ID  having COUNT(SUBJ_ID) > 1;

select l.LECTURER_ID,l.NAME,l.SURNAME,l_s.takenSubjects from lec_subject l_s join  LECTURER l on l_s.LECTURER_ID = l.LECTURER_ID ;

/*Five Join Requests*/
/*Show all the information of the universities where the most of the students survived at least before the fourth year of study*/
select u.UNIV_ID,u.UNIV_NAME,COUNT(s.STUDENT_ID) as number_students 
from STUDENT s join UNIVERSITY u on s.UNIV_ID = u.UNIV_ID where s.KURS>=4 group by u.UNIV_ID,u.UNIV_NAME;

/*Show all the students whoes absolute difference between length of the city where 
they live and length of city where they study is equal to the mark of the exam of any subject*/
select st.STUDENT_ID,st.NAME,st.SURNAME,e_m.EXAM_ID,e_m.MARK,un.CITY,
st.CITY,len(un.CITY) as university_city_length,len(st.CITY) as student_city_length,ABS(len(un.CITY) - len(st.CITY)) as differenceCities
from STUDENT st join UNIVERSITY un on st.UNIV_ID = un.UNIV_ID
join EXAM_MARKS e_m on e_m.STUDENT_ID = st.STUDENT_ID 
where ABS( len(un.CITY) - len(st.CITY)) = e_m.MARK;

/*Show all the universities as well as students who study one of the Technical courses in the best TOP 5 Universities */
 CREATE VIEW BEST_UNIVERSITY AS
 select TOP(5) * from UNIVERSITY order by RATING DESC;

 select st.STUDENT_ID,st.NAME,st.SURNAME,sub.SUBJ_NAME,b_u.UNIV_NAME,b_u.RATING from STUDENT st join EXAM_MARKS e_m on st.STUDENT_ID = e_m.STUDENT_ID
 join SUBJECT sub on e_m.SUBJ_ID = sub.SUBJ_ID 
 join BEST_UNIVERSITY b_u on b_u.UNIV_ID = st.UNIV_ID  where sub.SUBJ_NAME in ('Биология','Химия','Физика','Математика');

 /* Show all the possible RELATIVES among Students who could live together and 
 corresponsible Lecturers who could also be their far RELATIVE and could live in ANoTHer City */
 select  st1.STUDENT_ID,st1.SURNAME,st1.NAME,st1.CITY,st2.STUDENT_ID,st2.SURNAME,st2.NAME,st2.CITY,l.LECTURER_ID,l.SURNAME,l.NAME,l.CITY 
 from STUDENT st1 join STUDENT st2 on st1.SURNAME = st2.SURNAME AND st1.STUDENT_ID != st2.STUDENT_ID AND st1.CITY = st2.CITY 
 join LECTURER l on l.SURNAME = st1.SURNAME order by st2.STUDENT_ID;

 /*Represent TOP 3 cities where all the students and lecturers live in the same city as Univercity*/
 select TOP(3) un.CITY, COUNT(*) as total_number from STUDENT st 
 join UNIVERSITY un on  un.CITY = st.CITY  
 join LECTURER l on un.CITY = l.CITY group by un.CITY order by total_number desc;

/*Five SubQuery Requests*/

/*Show  the number students whoes scholarships are higher than the third highest scholarship*/
CREATE INDEX IX_scholarships on STUDENT(STIPEND);
select COUNT(STUDENT_ID) as student_number from STUDENT where STIPEND < (select max(STIPEND) as third_highest_scholarship 
from (select STIPEND from STUDENT where STIPEND < (select max(STIPEND) as second_max_scholarship 
from  (select STIPEND from STUDENT where STIPEND < (select max(STIPEND) as first_maximum_scholarship from STUDENT))a))b);
DROP INDEX STUDENT.IX_scholarships

/*  */

select UNIV_ID,UNIV_NAME,RATING,CITY from UNIVERSITY 
where UNIV_ID in (select UNIV_ID from STUDENT group by STUDENT.UNIV_ID having avg(STIPEND) 
> (select avg(STIPEND) from STUDENT where UNIV_ID = 58 )) order by UNIV_ID; 

/* Show all the possible students that Lecturer with Name 'Надежда' and Surname 'Бабкина' could teach any lesson*/

select * from STUDENT where STUDENT.STUDENT_ID in 
(select DISTINCT( EXAM_MARKS.STUDENT_ID) from EXAM_MARKS where EXAM_MARKS.SUBJ_ID in 
(select SUBJ_LECT.SUBJ_ID from SUBJ_LECT where SUBJ_LECT.LECTURER_ID in 
( select LECTURER_ID from LECTURER where NAME like 'Надежда' and SURNAME like 'Бабкина'))) order by STUDENT_ID;

/* Show all the Students whoes Name contains the exact MAX appearance all 'a' letter -1 in ANY Register  of the SURNAME of the LEctures */

select *,len(LOWER(NAME)) - len(replace(LOWER(NAME),'а','')) as student_a_appearance from STUDENT 
where len(LOWER(NAME)) - len(replace(LOWER(NAME),'а','')) = 
(select max( len(LOWER(SURNAME)) - len(replace(LOWER(SURNAME),'а',''))) -1 as a_max_apperance from Lecturer );

/* Show all the lecturers who teaches at least one subject that takes 3 credits(3 hours) a week. 
It is generally known that 1 credit takes 38 hours a semester. 
Let's Say that for example, 1.7 credits ~ 1 credit because its integer is 1 or 2.9 ~ 2 .*/

select * from LECTURER where LECTURER.LECTURER_ID in 
(select DISTINCT(LECTURER_ID) from SUBJ_LECT where SUBJ_LECT.SUBJ_ID in (select SUBJ_ID from SUBJECT where floor(hour/38) = 3));

/*Five Functions Requests*/

/*Show all the students whoes age is at least 18 years old. Consider Leap Years as normal Years*/
select *,DATEDIFF(day,BIRTHDAY,'2021-04-05')*1.0/365 as DateDiff from STUDENT where DATEDIFF(day,BIRTHDAY,'2021-04-05')*1.0/365 >= 18 order by DateDiff ;

/*Show the students with their appropriate Lecuters and subjects that they 
teach making the Surname and Name of the Student and Lecturer together by different functions*/
 select st.STUDENT_ID,CONCAT_WS(' ',st.SURNAME,st.NAME) as student_info,l.LECTURER_ID, 
 CONCAT(l.SURNAME,' ',l.NAME) as lecturer_info,sub.SUBJ_ID,sub.SUBJ_NAME
 from STUDENT st join UNIVERSITY un on st.UNIV_ID = un.UNIV_ID
 join EXAM_MARKS e_m on e_m.STUDENT_ID = st.STUDENT_ID 
 join SUBJECT sub on sub.SUBJ_ID = e_m.SUBJ_ID
 join SUBJ_LECT s_l on s_l.SUBJ_ID = sub.SUBJ_ID
 join LECTURER l on l.LECTURER_ID = s_l.LECTURER_ID AND l.UNIV_ID = un.UNIV_ID;
 
 /*Show the full_names,city as well as first letters of the Name and 
 Surname of the Lectures in one column whoes length of the City is less than 7 */
 select CONCAT_WS(' ',NAME,SURNAME) as full_name,CITY,
 CONCAT(SUBSTRING(NAME,1,1),'. ',SUBSTRING(SURNAME,1,1),'.') as short_name 
 from LECTURER where len(CITY)<7;

 /*Show all students whose zodiac sign is Cancer*/
 select *, UPPER('cancer') as zodiac_sign from STUDENT where 
 (MONTH(BIRTHDAY) = 6 and DAY(BIRTHDAY)>=22) OR (MONTH(BIRTHDAY) = 7 and DAY(BIRTHDAY)<=22);

 /*SHow all the subjects which square root of id is a good number. 
 Good number can be a figure square root of which is a beautiful quantity. For ex.: 1,4,9,16,25 etc*/
 select * from SUBJECT where SQRT(SUBJ_ID) in (select SUBJECT.SUBJ_ID from SUBJECT);