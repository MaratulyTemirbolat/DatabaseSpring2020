use train;
/* âñåãî ìóæ÷èí, æåíøèí, ïàññàæèðîâ ïîêàçàòü */

Create view men_number as
select count(*) as male_number from train where gender = 'male';
Create view woomen_number as
select count(*) as female_number from train where gender = 'female';
Create view people_number as
select count(*) as total_number from train;
select * from men_number,woomen_number,people_number; 
/*Group people by gender and check if the number matches the total number of passengers*/

Create view number_different_cabins as
select Cabin, COUNT(PassengerId) as number_repetition from train group by Cabin; 

select * from number_different_cabins; 
/*Count the number of different cabins*/
Create view passengers_without_departure as
select * from train where Embarked is NULL; 
select * from passengers_without_departure;
/*Write a query to display information about those passengers whose data does not indicate 
the port of departure.*/
CREATE VIEW survived_people_genders AS
select (count(survived))*100 as survived_percent,gender,survived from (select survived, gender from train where survived =1)a group by gender,Survived;

CREATE VIEW all_people as
select count(survived) as all_sur_people,survived from train where survived = 1 group by survived;

select s_p_g.survived_percent/a_p.all_sur_people,s_p_g.gender from survived_people_genders s_p_g join all_people a_p 
on s_p_g.survived = a_p.survived; 
/*Write a query to display the percentage of men and women who survived the disaster.*/

CREATE VIEW average_age_victims as
select AVG(age) average_age from train where survived = 0 and age is not NULL;

select * from average_age_victims;
/*Write a query to display the average age of the victims.*/

ALTER table train
add cabin_repetition integer;

UPDATE train
SET cabin_repetition = (select count(*) from train as t group by cabin having t.Cabin=train.cabin); /*Fill in all the columns with non NULL cabin type*/

UPDATE train
SET cabin_repetition = number_repetition 
from (select count(PassengerId) as number_repetition from train group by Cabin)a where cabin is NULL; /*Fill in all the columns with correspondent number where cabin type is NULL*/

select * from train;
/*Add a column indicating the number of repetitions for each cabin. The absence of a cabin 
number should also be taken into account.*/

CREATE VIEW without_name as
select name,
SUBSTRING(name,1,CHARINDEX(',',name)-1)as lastName,
SUBSTRING(name,CHARINDEX('(',name),(CHARINDEX(')',name) - CHARINDEX('(',name))+1) as maiden_name,PassengerId from train;

CREATE VIEW married_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,CHARINDEX(' ',name,CHARINDEX('(',name)-1) - CHARINDEX('.',name)) 
as first_name,PassengerId from train where CHARINDEX('(',name) !=0;

CREATE VIEW not_married_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,len(name) - CHARINDEX('.',name)) 
as first_name,PassengerId from train where CHARINDEX('(',name) =0;

CREATE VIEW total_names as
select * from married_names
UNION 
select * from not_married_names ;

select w_n.name,w_n.lastName,t_n.first_name,w_n.maiden_name from total_names t_n join without_name w_n
on t_n.PassengerId = w_n.PassengerId;

/*Separate the passenger names into four columns: the original name column(ÏÎ ÓÌÎË×ÀÍÈß èçíà÷àëüíî), the passenger  last name(ÏÅÐÂÎÅ äî çàïÿòòîé) column,
the passenger first name(ÏÎÑËÅ ÌÐ, ÌÈÑÑ..ÂÑÅ ÈÌß) column without regalia, and the maiden name column of married women(ÒÎ ×ÒÎ Â ÑÊÎÁÊÀÕ).*/

CREATE VIEW allRegalies as
select substring(name,CHARINDEX(',',name)+1,(CHARINDEX('.',name)-CHARINDEX(',',name))-1) as regalia from train;

select regalia, count(regalia) as number_of_repetition from allRegalies group by regalia; 
/*Show the number of regalia (Mr., Mrs, Miss, Master, Rev, Col, etc.)*/ 
create view condition_one as
select * from train where SibSp >= 0 and ParCh >= 1;
Create view condition_two as
select * from train where SibSp >= 1 and ParCh = 0;

select * from condition_one
UNION
select * from condition_two;

/*Divide people into families. More than one select may be needed to complete the task.*/

select name, (SibSp + ParCh + 1) as total_number_members  from train; 

/* Write a query to display the number of family members for each passenger, taking into 
account this passenger.*/

Create view children_last_names as
select name, SUBSTRING(name,1,CHARINDEX(',',name)-1)as lastName,PassengerId,SibSp,ParCh from train where Age < 18;

CREATE VIEW married_children_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,CHARINDEX(' ',name,CHARINDEX('(',name)-1) - CHARINDEX('.',name)) 
as first_name,PassengerId,SibSp,ParCh from train where CHARINDEX('(',name) !=0 AND age <18;

CREATE VIEW not_married_children_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,len(name) - CHARINDEX('.',name)) 
as first_name,PassengerId,SibSp,ParCh from train where CHARINDEX('(',name) =0 AND age < 18;

Create view all_children_first_names as
select * from married_children_names
UNION
select * from not_married_children_names;

Create view children as
select l_n.Name,l_n.lastName,f_n.first_name,l_n.SibSp,l_n.ParCh
from 
all_children_first_names  f_n
join 
children_last_names l_n
on f_n.PassengerId = l_n.PassengerId;

select * from children;

Create view parents_last_names as
select name, SUBSTRING(name,1,CHARINDEX(',',name)-1)as lastName,PassengerId,SibSp,ParCh from train where Age >= 18;

CREATE VIEW married_parrents_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,CHARINDEX(' ',name,CHARINDEX('(',name)-1) - CHARINDEX('.',name)) 
as first_name,PassengerId,SibSp,ParCh from train where CHARINDEX('(',name) !=0 AND age >=18;

CREATE VIEW not_married_parents_names as
select SUBSTRING(name,CHARINDEX('.',name)+1,len(name) - CHARINDEX('.',name)) 
as first_name,PassengerId,SibSp,ParCh from train where CHARINDEX('(',name) =0 AND age >= 18;

Create view all_parents_first_names as
select * from married_parrents_names
UNION
select * from not_married_parents_names;

Create view parents as
select l_n.Name,l_n.lastName,f_n.first_name,l_n.SibSp,l_n.ParCh
from 
all_parents_first_names  f_n
join 
parents_last_names l_n
on f_n.PassengerId = l_n.PassengerId;

select * from parents;
/*Separate children and parents. Create views for each of the below queries. The last names 
and first names of passengers should be in different columns.*/


select lastName,first_name from children where ParCh = 0;
/*A) Write a query to display the children traveling without their parents.*/

select lastName,first_name,ParCh from children where ParCh > 0 ;
/*B) Write a query to display the children traveling with their parents.*/

select lastName,first_name from parents where SibSp = 0 and ParCh>0;
/*C) Write a query to display the single parents (without SibSp).*/

select * from parents where SibSp >=1 and ParCh > 0; 
/*D) Write a query to display the parents who have SibSp.*/

Create view without_first_name as
select name, 
SUBSTRING(name,Charindex('"',name)+1,CHARINDEX('"',name,CHARINDEX('"',name)+1) - CHARINDEX('"',name)-1) as short_name,
SUBSTRING(name,1,CHARINDEX(',',name)-1)as lastName,PassengerId, age, Gender,Survived
from train  where CHARINDEX('"',name) !=0 AND (Age >= 10 AND Age <=35) AND Gender like 'female' AND Survived = 0;

Create view cond1 as
select SUBSTRING(name,CHARINDEX('.',name)+1,CHARINDEX(' ',name,CHARINDEX('(',name)-1) - CHARINDEX('.',name)) 
as first_name,PassengerId,age,Gender,Survived from train where CHARINDEX('(',name) !=0 AND age >=10 AND age <=35 AND Gender like 'female' AND Survived = 0 and CHARINDEX('"',name) !=0;

Create view cond2 as
select SUBSTRING(name,CHARINDEX('.',name)+1,len(name) - CHARINDEX('.',name)) 
as first_name,PassengerId,age,Gender,Survived from train where CHARINDEX('(',name) =0 AND age >= 10 AND age <=35 AND Gender like 'female' AND Survived = 0 and CHARINDEX('"',name) !=0;

Create view first_names_total as
select * from cond1
UNION
select * from cond2;

Create view last_exercise as
select f_n_t.first_name,w_f_n.lastName,w_f_n.short_name,w_f_n.Age,w_f_n.Gender,w_f_n.Survived from 
first_names_total f_n_t
join
without_first_name w_f_n
on f_n_t.PassengerId = w_f_n.PassengerId;

select * from last_exercise;

/*Write a query to display the first_names(can be together with short_names because can organize first name if not in brackets), 
short_names, last_names of the victims' full names with the ages from 10 to 35 and they must be females. 
Short names are said to be names in form "Name". For example, "Daisy". 
Use views if it is necessary with joins or unions and so on.  */

