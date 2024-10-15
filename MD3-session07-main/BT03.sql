create database s07_bt3;
use s07_bt3;
create table customer(
	id int primary key auto_increment,
    name varchar(25),
    age int
);
create table orders(
	id int primary key auto_increment,
    c_id int,
    o_date date,
    total_price int,
    constraint fk_o1 foreign key(c_id) references customer(id)
);
create table product (
	id int primary key auto_increment,
    name varchar(25),
    price int
);
create table order_detail(
	orders_id int,
    product_id int,
    quantity int,
    constraint fk_od1 foreign key(orders_id) references orders(id),
    constraint fk_od2 foreign key(product_id) references product(id)
);
#insert
insert into customer(name,age) values('Minh Quan',10),('Ngoc Oanh',20),('Hong Ha',50);
insert into orders(c_id,o_date) values
(1,str_to_date('3/21/2006','%c/%d/%Y')),
(2,str_to_date('3/23/2006','%c/%d/%Y')),
(1,str_to_date('3/16/2006','%c/%d/%Y'));
insert into product(name,price) values
('May Giat',3),('Tu Lanh',5),('Dieu Hoa',7),('Quat',1),('Bep Dien',2);
insert into order_detail(orders_id,product_id,quantity) values
(1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);

# Hiển thị các thông tin 
select od.orders_id as 'oID', od.product_id as 'cID', o.o_date as 'oDate', o.total_price as 'oTotalPrice' from orders as o 
inner join order_detail as od on o.id = od.orders_id
order by o.o_date desc;

# Hiển thị tên và giá của các sản phẩm có giá cao nhất
select name as 'pName',price as 'pPrice' from product where price = (select Max(price) from product);

# Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
select c.name as'cName', p.name as 'pName' from customer as c 
inner join orders as o on c.id = o.c_id
inner join order_detail as od on o.id = od.orders_id
inner join product as p on p.id = od.product_id;

# Hiển thị tên khách hàng không mua bất kỳ sản phẩm nào
select name as 'cName' from customer where id NOT IN (select distinct c_id from orders);

# Hiển thị chi tiết của từng hoá đơn
select o.id as 'oID', o.o_date as 'oDate', od.quantity as 'odQTY', p.name as 'pName', p.price as 'pPrice' from orders as o 
inner join order_detail as od on o.id = od.orders_id
inner join product as p on p.id = od.product_id;

# Hiển thị mã hoá đơn, ngày bán và giá tiền của từng hoá đơn
select o.id as 'oID', o.o_date as 'oDate',Sum(od.quantity * p.price) as total from orders as o 
inner join order_detail as od on o.id = od.orders_id
inner join product as p on p.id = od.product_id
group by o.id;

# Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị
CREATE VIEW sales AS
SELECT SUM(total) as 'Sales' from 
(select o.id as 'oID', o.o_date as 'oDate',Sum(od.quantity * p.price) as total from orders as o 
inner join order_detail as od on o.id = od.orders_id
inner join product as p on p.id = od.product_id
group by o.id) as total_price;

# Xoá tất cả các ràng buộc khoá ngoại, khoá chính của tất cả các bảng
alter table orders drop foreign key fk_o1;
alter table order_detail drop foreign key fk_od1;
alter table order_detail drop foreign key fk_od2;
ALTER TABLE customer
MODIFY COLUMN id INT;
ALTER TABLE customer
DROP PRIMARY KEY;
ALTER TABLE orders
MODIFY COLUMN id INT;
ALTER TABLE orders
DROP PRIMARY KEY;
ALTER TABLE product
MODIFY COLUMN id INT;
ALTER TABLE product
DROP PRIMARY KEY;

# Tạo 1 trigger tên là cusUpdate trên bảng customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Orders cũng được sửa theo
delimiter //

create trigger cusUpdate
before update on customer
for each row
begin
	update orders set c_id = new.id where c_id = old.id;
end//
delimiter ;
update customer set id = 4 where id =1;
select * from orders

# Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm xoá sản phẩm và các thông tin liên quan đến sản phẩm đó ở trong bảng order_detail
delimiter //
create procedure delProduct (IN product_name varchar(20))
begin
	IF not exists ( select * from product where name = product_name)
    then signal sqlstate '45000' set message_text = 'Cant find this product name';
    else
		delete from order_detail where product_id = (select id from product where name = product_name);
		delete from product where name = product_name;
	end if;
end //
delimiter ;
