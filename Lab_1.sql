create database Shop;
use Shop;

create table Items( 
id int IDENTITY(1,1),
name nvarchar(50) not null,
const float not null,
description nvarchar(200),
constraint Items_PK primary key(id))

drop table Items
INSERT INTO [Items] ([name], [description])
VALUES ('�����', '����� ������ � ��������'),
	   ('��������', '������');


create table Supermarkets( 
id int not null,
adress nvarchar(200) not null,
type nvarchar(50) not null,
description nvarchar(200),
constraint SUPERMARKET_PK primary key(id))

------------------------
GO
CREATE PROCEDURE GET_ADRESS_SUPERMARKETS 
					@adress nvarchar(200)
AS
BEGIN
SELECT * FROM Supermarkets  WHERE adress = @adress
END
EXEC GET_ADRESS_SUPERMARKETS '��. ���������';
-------------------------
 SELECT adress, ['������'], ['�����'], ['����������']
   FROM dbo.Supermarkets
   PIVOT (count(description)for type in ( ['������'], ['�����'], ['����������'])
           ) AS test_pivot_adress




select * from Supermarkets;
INSERT INTO [Supermarkets] ([id],[adress], [type], [description])
VALUES (3, '��. 1���','�����', '�����'),
	   (4,'��. ������','����������', '����');

create table Promo( 
id int not null,
item_id int not null,
amount int default 1,
weight float,
cost_new float,
time_until date,
supermarket_id int not null,
constraint PROMO_PK primary key(id))


INSERT INTO [Promo] ([id],[item_id], [amount], [weight],[cost_new],[time_until],[supermarket_id])
VALUES (1, 1, 12, 0.56, 34, '21.04.2020', 1),
	   (2, 2, 43, 0.26, 14, '22.04.2020', 1);

create table Clients( 
id int not null,
name nvarchar(50) not null,
bonus float,
age int,
constraint CLIENTS_PK primary key(id))


INSERT INTO [Clients] ([id],[name], [bonus], [age])
VALUES (1, 'Septilko Nastya', 0, 20),
	   (2, 'Ivanova Irina', 50, 23);

create table Orders( 
id int not null,
client_id int not null,
total float not null,
bonus float,
buy_date date not null,
supermarket_id int not null,
constraint ORDERS_PK primary key(id))


INSERT INTO [Orders] ([id],[client_id], [total], [bonus],[buy_date],[supermarket_id])
VALUES (1, 1, 400, 30.36,'21.04.2010', 2),
	   (2, 1, 100, 10.36,'21.04.2010', 1);

create table Purchases( 
id int not null,
order_id int not null,
item_id int not null,
amount int not null,
weight float,
constraint PURCHASES_PK primary key(id)

INSERT INTO [Purchases] ([id],[order_id], [item_id], [amount],[weight])
VALUES (1, 1, 2, 30, 2.34),
	   (2, 1, 2, 30, 2.34);

alter table Promo add constraint Promo_fk0 FOREIGN KEY (item_id) references Items(id);
alter table Promo add constraint Promo_fk1 FOREIGN KEY (supermarket_id) references Supermarkets(id);

alter table Orders add constraint Orders_fk0 FOREIGN KEY (client_id) references Clients(id);
alter table Orders add constraint Orders_fk1 FOREIGN KEY (supermarket_id) references Supermarkets(id);

alter table Purchases add constraint Purchases_fk0 FOREIGN KEY (order_id) references Orders(id);
alter table Purchases add constraint Purchases_fk1 FOREIGN KEY (item_id) references Items(id);


--Trigger
go
CREATE TRIGGER IF_PPOMO_EXISTS
ON Orders AFTER DELETE
AS
BEGIN
	DELETE p FROM Purchases p
		WHERE 0 = (SELECT COUNT(*) FROM Orders o WHERE o.id = p.order_id);
END

--Procedure
go 
CREATE PROCEDURE ADD_ITEMS
					@Id int,
					@name nvarchar(50),
					@cost float,
					@description nvarchar(200)
AS
BEGIN
INSERT INTO [Items] ([id],[name], [const], [description])
VALUES (@Id,@name,@cost,@description );
END
EXEC ADD_ITEMS 4,'����', 14.4, '�����  �������';
select * from Items;

--������
CREATE INDEX i1 ON Items (id);

--�������������
go
CREATE VIEW OrdersProductsCustomers AS 
SELECT Orders.buy_date AS OrderDate, 
		Clients.name AS Client,
		Items.name As Items  
FROM Orders INNER JOIN Items ON Orders.id = Items.Id
INNER JOIN Clients ON Orders.Id = Clients.Id

select * from OrdersProductsCustomers
go
--
go 
CREATE FUNCTION testF(@n1 int, @n2 as int)

RETURNS int
AS
BEGIN
Return (@n1*@n2)
END


select dbo.testF(5,8);