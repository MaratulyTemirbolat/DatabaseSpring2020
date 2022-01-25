create table members(
    member_number integer constraint pk_members PRIMARY KEY,
    member_name varchar(40) not NULL,
    member_address varchar(30) not NULL
);

create table dinners(
    dinner_number integer constraint  pk_dinners PRIMARY KEY,
    dinner_date date Not Null,
    dinner_venue_code varchar(20) unique NOT NULL,
    dinner_food_code varchar(15) unique NOT NULL,
    constraint fk_food FOREIGN KEY (dinner_food_code) REFERENCES food(food_code),
    constraint fk_dinners FOREIGN KEY (dinner_venue_code) REFERENCES venues(venue_code)
);

create table venues(
    venue_code varchar(20) constraint pk_venues PRIMARY KEY,
    venue_description varchar(40) NOT NULL
);

create table food(
    food_code varchar(15) constraint pk_food PRIMARY KEY,
    food_description varchar(20) not NULL
);