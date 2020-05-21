use Shop;

--1
--�	����� ������;
SELECT count(*) FROM Orders
	WHERE buy_date BETWEEN '2009-06-01' AND '2012-06-01';
-------------------------------------------�	��������� �� � ����� ������� ������ (� %);
SELECT id, volume_of_sales, buy_date
	,sum(volume_of_sales) OVER()
	,(100.00*volume_of_sales / (sum(volume_of_sales) OVER()))/100.00 AS "Percent"  
FROM Orders   
	WHERE buy_date BETWEEN '2009-06-01' AND '2020-06-01'
group by id, volume_of_sales, buy_date;

-------------------------------------------�	��������� � ��������� ������� ������ (� %).
SELECT id, volume_of_sales, buy_date
	,max(volume_of_sales) OVER()
	,(100.00*volume_of_sales / (max(volume_of_sales) OVER()))/100.00 AS "Percent"  
FROM Orders   
	WHERE buy_date BETWEEN '2009-06-01' AND '2020-06-01'
group by id, volume_of_sales, buy_date;


-----------------------------------------
select * from Items
INSERT INTO [Items] ([id],[name], [const], [description])
VALUES 
(13,'�������', 32.2, '����� ������ � ��������'),
(14,'�������', 32.2, '����� ������ � ��������'),
(15,'�������', 32.2, '����� ������ � ��������'),
(16,'�������', 32.2, '����� ������ � ��������'),
(17,'�������', 32.2, '����� ������ � ��������'),
(18,'�������', 32.2, '����� ������ � ��������'),
(19,'�������', 32.2, '����� ������ � ��������'),
(20,'�������', 32.2, '����� ������ � ��������'),
(21,'�������', 32.2, '����� ������ � ��������'),
(22,'�������', 32.2, '����� ������ � ��������'),
(23,'�������', 32.2, '����� ������ � ��������'),
(24,'�������', 32.2, '����� ������ � ��������'),
(25,'�������', 32.2, '����� ������ � ��������'),
(26,'�������', 32.2, '����� ������ � ��������'),
	   (27,'��������', 322.4,'������');
--3
SELECT * , ROW_NUMBER() OVER(PARTITION BY Id ORDER BY Id) AS rownum
FROM Items;

--3
DECLARE
  @pagenum  AS INT = 1,
  @pagesize AS INT = 20;
WITH C AS
(
  SELECT ROW_NUMBER() OVER(ORDER BY [name]) AS rownum,
    [id],[name], [const], [description]
  FROM Items
)
SELECT rownum,  [id],[name], [const], [description] FROM C
WHERE rownum BETWEEN (@pagenum - 1) * @pagesize + 1 AND @pagenum * @pagesize ORDER BY rownum;



--4. ROW_NUMBER() delete dublicates
SELECT count(*) FROM Items;
delete x from (
  select *, rn=row_number() over (partition by   [name], [const] order by [name])from Items
) x
where rn > 1;


----------

INSERT INTO [Orders] ([id],[client_id],[total], [bonus],[buy_date],[supermarket_id],[volume_of_sales])
VALUES (3, 1, 400, 30.36,'21.04.2019', 2,880),
(4, 1, 400, 30.36,'22.04.2020', 2,200),
(5, 1, 400, 30.36,'23.04.2020', 2, 100),
(6, 1, 400, 30.36,'24.04.2020', 2, 1200),
(7, 1, 400, 30.36,'24.04.2020', 2, 500),
(8, 1, 400, 30.36,'25.04.2020', 2,600),
	   (9, 1, 100, 10.36,'26.04.2020', 2, 999);


--5 ������� ��� ������� ������� �����  �������

SELECT Orders.client_id,SUM(Orders.total)  as count ,
  RANK() OVER(ORDER BY SUM(Orders.total)  DESC) AS rank
FROM Orders 
  JOIN Clients ON Orders.client_id = Clients.id 
GROUP BY Orders.client_id;


select * from Clients
select * from Orders



--6
SELECT Orders.client_id,count(Orders.id)  as count_order ,
  RANK() OVER(ORDER BY count(Orders.id)  DESC) AS rank
FROM Orders 
  JOIN Clients ON Orders.client_id = Clients.id 
GROUP BY Orders.client_id;