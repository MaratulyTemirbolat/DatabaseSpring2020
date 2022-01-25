create table orders(
    order_id integer constraint pk_orders PRIMARY KEY,
    order_date date not null,
    customer_id integer not null,
    constraint fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

insert into orders values (1006,'24-10-2009',2);
insert into orders values (1007,'25-10-2009',6);

create table customers(
    customer_id integer constraint pk_customers PRIMARY KEY,
    customer_name varchar(40) not NULL,
    customer_state varchar(10) not NULL
);

insert into customers values (2,'Apex','NC');
insert into customers values (6,'Acme','GA');

create table products(
    product_id integer constraint  pk_products PRIMARY KEY,
    product_description varchar(15) unique NOT NULL,
    product_price integer NOT NULL
);
insert into products values (7,'Table',800);
insert into products values (5,'Desk',325);
insert into products values (4,'Chair',200);
insert into products values (11,'Dresser',500);

create table order_items(
    order_items_id integer,
    order_items_product_id integer,
    order_items_quantity integer NOT NULL,
    constraint pk_order_items PRIMARY KEY(order_items_id,order_items_product_id)
);
insert into order_items values (1006,7,1);
insert into order_items values (1006,5,1);
insert into order_items values (1006,4,5);
insert into order_items values (1007,11,4);
insert into order_items values (1007,4,6);

select min(order_date) as minimum_date from orders ;

select UPPER(product_description) as upper_description from products order by length(product_description);

select o.order_date, c.customer_name,c.customer_state
from orders o join customers c
on o.customer_id = c.customer_id
where o.order_date < '25-10-2009';

select *
from orders o join order_items ot
on o.order_id = ot.order_items_id
where ot.order_items_quantity > 1;

select * from orders where orders.customer_id = (select  customer_id from customers where customer_name like  'A%x');