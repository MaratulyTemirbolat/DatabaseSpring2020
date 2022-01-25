create table applications(
    application_id integer constraint pk_application PRIMARY KEY,
    application_date date NOT NULL,
    application_student_id integer NOT NULL,
    application_bowling_center_id integer NOT NULL,
    application_school_id integer NOT NULL,
    application_gpa_point real,
    constraint min_point CHECK(application_gpa_point >= 3.5),
    constraint fk_app_student FOREIGN KEY(application_student_id) REFERENCES applicants(student_id),
    constraint fk_app_school FOREIGN KEY(application_school_id) REFERENCES schools(school_id),
    constraint fk_app_bow_center FOREIGN KEY (application_bowling_center_id) REFERENCES bowling_centers(bow_center_id)
);
insert into applications values (1,'2021-01-31',1,23,13,3.83);
insert into applications values (14,'2021-02-23',3,32,15,3.5);
insert into applications values (9,'2021-01-15',2,32,30,4.0);
insert into applications values (15,'2021-01-11',5,55,26,3.9);
insert into applications values (2,'2021-01-25',4,45,26,3.6);
drop table applications;

create table applicants(
    student_id serial constraint pk_applicant PRIMARY KEY,
    student_first_name varchar(20) NOT NULL,
    student_last_name varchar(20) NOT NULL,
    student_phone_number varchar(20),
    student_email varchar(20) unique,
    student_address varchar(30) NOT NULL,
    student_age integer,
    constraint  min_age CHECK(student_age >=18)
);
insert into applicants values (default,'Temirbolat','Maratuly','123.456.789','t_maratuly@kbtu.kz','Erzhanova 28','20');
insert into applicants values (default,'Assanali','Moldash','228.009.123','a_moldash@kbtu.kz','Mailina 19','19');
insert into applicants values (default,'Temirlan','Serikov','987.423.1532','t_serikov@kbtu.kz','Tole Bi 59','21');
insert into applicants values (default,'Anuar','Sarsengaliev','234.526.749','sars_covid@gmail.com','Turgut Ozala 27','20');
insert into applicants values (default,'Tamerlan','Kunkash','213.423.1234','t_kuankash@kbtu.kz','Ermekova 39','21');
drop table applicants;

create table schools(
    school_id integer constraint  pk_school PRIMARY KEY,
    school_address varchar(40) NOT NULL,
    school_name varchar(40) NOT NULL,
    school_phone_number varchar(40) NOT NULL
);
insert into schools values (13,'Erzhanova 36','School 48','123.222.333');
insert into schools values (26,'Respublika 22','School 97','423.412.555');
insert into schools values (15,'Vostok 4','School 38','999.555.234');
insert into schools values (30,'Tole Bi 6','School 100','754.945.888');
drop table schools;

create table bowling_centers(
    bow_center_id integer constraint pk_bowling_center PRIMARY KEY,
    bow_center_name varchar(40) NOT NULL,
    bow_center_address varchar(40) NOT NULL,
    bow_center_phone_number varchar(40) NOT NULL,
    bow_center_grade real,
    constraint upper_limit_grade CHECK (bow_center_grade <=5.0),
    constraint lower_limit_grade CHECK (bow_center_grade >= 0.0)
);
insert into bowling_centers values (23,'Fox','Lugovaya 19','213.412.421',4.3);
insert into bowling_centers values (32,'KBTU','Tole Bi 59','952.123.531',4.5);
insert into bowling_centers values (45,'SDU','Kaskelen 2','533.135.928',4.0);
insert into bowling_centers values (55,'KarGU','Universitetskaya 5','314.532.523',3.9);
drop table bowling_centers;

create table recommendations(
    recommendation_id serial constraint pk_recommendation PRIMARY KEY,
    recommendation_application_id integer,
    recommendatio_date date NOT NULL,
    constraint fk_recommendation FOREIGN KEY (recommendation_application_id) REFERENCES applications(application_id)
);
insert into recommendations values (2,14,'2020-12-22');
insert into recommendations values (1,1,'2020-12-20');
insert into recommendations values (10,9,'2020-12-26');
insert into recommendations values (15,15,'2020-12-29');
insert into recommendations values (19,2,'2020-12-30');
drop table recommendations;

select * from applications;
select * from applicants;
select * from bowling_centers;
select * from schools;
select * from recommendations;

select * from
applications a join bowling_centers b
on a.application_bowling_center_id = b.bow_center_id;

select student_first_name,student_last_name from applicants where length(student_first_name) <10 order by student_age ASC ;

select * from applicants where student_first_name like 'Temir%';

select * from applicants where
student_id IN (select application_student_id from applications where application_gpa_point BETWEEN 3.5 AND 3.8);

select a.application_date, a.application_gpa_point, s.student_first_name,s.student_last_name
from applications a join applicants s
on a.application_student_id = s.student_id
where a.application_date BETWEEN '2021-01-01' AND '2021-01-31';

